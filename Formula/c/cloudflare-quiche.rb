class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.23.7",
      revision: "51cfd8a6f790064328273e9eaec83193c7b4171b"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90269b7e0679575ff9910db940f0f6d57e6221c30ebd8f119fd1c451b92d2a47"
    sha256 cellar: :any,                 arm64_sonoma:  "e744358545cb3808d321956c851f94071d50bba4318e0eda225bdd56cf027800"
    sha256 cellar: :any,                 arm64_ventura: "1a8c8e905dfdb07033c6c8ec8fa6b74bf3747540499a7b43d4f79aba919d95f8"
    sha256 cellar: :any,                 sonoma:        "7bf9f86f58942d9768e024129621a63ba1925648d22de594f7ab2685182d3307"
    sha256 cellar: :any,                 ventura:       "6097a4bae5e3fb9f5ec4f52369fd1aae350b688524eca657f35aa594926d7069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7594a535bd6c7100017a6f877ed9b80f3ad020308fce6c4ff38cd94aae02e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8388288dda3d0959536bda2d69a7a007849923839d8b7c69d411983dd4cc280"
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
