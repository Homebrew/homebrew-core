class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.23.2",
      revision: "c5fc0679ece63636a2264ef273c75f08a405fdf7"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce4557b96999526df17af6542bbe364a39b543e2439864be53014137397c69d1"
    sha256 cellar: :any,                 arm64_sonoma:  "220432f61056cebfe7c8ec17fb517952453129fbd1e901712ccf9778c5f8c067"
    sha256 cellar: :any,                 arm64_ventura: "41886440961660f8a8e8a1b0b04499d528ff19a4b0b48c312c036ec71b886bb5"
    sha256 cellar: :any,                 sonoma:        "6fa5c717c65318ebfe51c8064073f8efe9fadc0f117e44d81300e64898b7cd93"
    sha256 cellar: :any,                 ventura:       "9c2ca9c5075176e4e66c50645631da77978662e3970f7d9624fee5dd01260861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4adbca974ad4e8a296889e0aed4f1e6c70d73a2be662f79773176a5fea29c4f7"
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
    (testpath/"test.c").write <<~C
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end
