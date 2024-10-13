class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.22.0",
      revision: "4ff56ec2566622980bbb0e0d7b9217254d97c4ba"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7f3cdeeb6ae9c59ef17151d9a55629b062f1d25e8589e7dfd67c2bc4d5d9e608"
    sha256 cellar: :any,                 arm64_sonoma:   "edce91e6f01349436adc89ddb657619ee44b50dc4c0d2348a3a17938abdf948c"
    sha256 cellar: :any,                 arm64_ventura:  "7c113bc0ac14fe5bfcbfecf79cf1d4cdb94c1efbb1ac31808347a252ccad7488"
    sha256 cellar: :any,                 arm64_monterey: "6aff3a2f065cdb912aeca3cb46992ac119b02c56e0d51ce2c823bb2ca413b8d8"
    sha256 cellar: :any,                 sonoma:         "876f91d5a1f9737a71767019e124f9337a1f52db81e4fa3d4ec4a27508733096"
    sha256 cellar: :any,                 ventura:        "04b58c13fcbdec3306c12fa24175392d1ce85fd60e668dda649062194d76e49a"
    sha256 cellar: :any,                 monterey:       "3433639f9423e5d994151f04802f9b33972e25a7f0d456730dc44a2d4de41789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9242ad03216fa5dd05d2246674443884388ef7360276476ff0a1dd5383799df1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "-j", "1", "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/libquiche.a"
    include.install "quiche/include/quiche.h"

    # install dylib with version and symlink
    lib.install "target/release/#{shared_library("libquiche")}"
    if OS.mac?
      mv "#{lib}/libquiche.dylib", "#{lib}/libquiche.#{version.major_minor_patch}.dylib"
      lib.install_symlink "#{lib}/libquiche.#{version.major_minor_patch}.dylib" => "#{lib}/libquiche.dylib"
    else
      mv "#{lib}/libquiche.so", "#{lib}/libquiche.so.#{version.major_minor_patch}"
      lib.install_symlink "#{lib}/libquiche.so.#{version.major_minor_patch}" => "#{lib}/libquiche.so.#{version.major}"
      lib.install_symlink "#{lib}/libquiche.so.#{version.major_minor_patch}" => "#{lib}/libquiche.so"
    end

    # install pkgconfig file
    pc_path = "target/release/quiche.pc"
    # the pc file points to the tmp dir, so we need inreplace
    inreplace pc_path do |s|
      s.gsub!(/includedir=.+/, "includedir=#{include}")
      s.gsub!(/libdir=.+/, "libdir=#{lib}")
    end
    (lib/"pkgconfig").install pc_path
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
    (testpath/"test.c").write <<~EOS
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end
