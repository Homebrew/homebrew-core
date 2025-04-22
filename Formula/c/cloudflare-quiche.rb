class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.1",
      revision: "7f42375a1ed4786d5ff7b0357b52fbe5ca43a666"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "055a11e5114fe5e49c5d9cac1d0d010cf902b0f41c0ea4f0aab41804bad9b7c3"
    sha256 cellar: :any,                 arm64_sonoma:  "c64575c988090fecd65e8c729aeaa286800e308f5e4d122fcabe398b4138b9bc"
    sha256 cellar: :any,                 arm64_ventura: "26ac2f5d559bd5eea39999c1bafc32ff2bc57bdb1913e41bf19fa8ae5d88e271"
    sha256 cellar: :any,                 sonoma:        "46457304aae09ce95328d511a2dd5d1dadd2a28624d7a95c2fe7559a3994be41"
    sha256 cellar: :any,                 ventura:       "f87eb073511cac63841c85377848c4161fdfe6bbb6e41725bb1d4b45406f3223"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d93ad6e9ade1c3fefd629a9b4ce44beefbd98822276f7ca6d63f4d422795af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3aa0f70eeb949af49515448054d999dc6392adde69ab32d4595029120f486d"
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
