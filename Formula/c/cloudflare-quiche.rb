class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.4",
      revision: "70d6d3e233568e906e66179a56c93cf9b0616899"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3dd5bd2de1a66a24a952b0826c212e860634d56c92cf6204cff4fa63597c95d9"
    sha256 cellar: :any,                 arm64_sonoma:  "9ae12b15acc708f605c4d973275626c6ddf3541eb48233c31d842a6fc6ddfe23"
    sha256 cellar: :any,                 arm64_ventura: "757fa3b626495ae2a535913c1bbaefc558ff5c68c24ff697c8c819f7de802f6a"
    sha256 cellar: :any,                 sonoma:        "614250b372f6caf00b8a50b90dc516dc3c6285e1f8b0a360bea6b15a4b9cc6c7"
    sha256 cellar: :any,                 ventura:       "f91dac7a21e7c416c4aaa54fcd15b2aa5f5e6ba67029103555ed1aa0ccc1535f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "258a1eabf2698186a8926e0ac2704c4adf5e26321336089458da6611673b1272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a64a404ebc5398a01cfa9446497e75c71063bf07690a943de8c775e69e75cb"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

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
