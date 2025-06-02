class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.2",
      revision: "28cb72b7c6a1f134f4d2e2f36ed04a81e113a0a6"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "324c6c5f60ef9e19e18555a94b15d76645b0348e6222c81790b7a8033cf1c122"
    sha256 cellar: :any,                 arm64_sonoma:  "ce46532106028067d8aac3979abf679093363c53c2f4ea4eed8a36efad2d556d"
    sha256 cellar: :any,                 arm64_ventura: "b75d581d95be7fec1a274c2d9bc29068a6338d4359e6a5f772500aa99af1706b"
    sha256 cellar: :any,                 sonoma:        "e9cfbcf26a86579bc0458d16e97f4349df02698a394bb58f416b3c71e24d8ca7"
    sha256 cellar: :any,                 ventura:       "d365dedaf43b07242df7251495cfe241c0cb0b3791be130b26e6cf5c017329d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3d1f486469db34a48a4054b4ae80641737551791990720eddd1e5c891fc1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f02d9c5eee232278edf74c2da0c8e828c5693f3aac1bc618d75945822e41d04"
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
