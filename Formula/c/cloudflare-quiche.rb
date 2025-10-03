class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.6",
      revision: "020a43a0a5eed76f57dd3ce5012149aa576c594d"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94cf2f6d446be6967e0ff5c897119207150b727f19393c6274be619010818ec6"
    sha256 cellar: :any,                 arm64_sequoia: "9fdfdfd55a6503b9aca9a34c7e35077df3041cafb794804f35346ff340821d57"
    sha256 cellar: :any,                 arm64_sonoma:  "ad2a4fbf4f65847baa4aeec6d238951104c14aba3a982c7b0eeb6f98df0ed157"
    sha256 cellar: :any,                 arm64_ventura: "9f08f4d1db96fe372ed1d5a548fdedf54102442bffe182f33ebc4fd745fdc8fc"
    sha256 cellar: :any,                 sonoma:        "dae3a219d175e8bdc73500e2765719dc3a4feac6bb71e0402be87dba907ba1c3"
    sha256 cellar: :any,                 ventura:       "95150c13315bb303844632259de94ef54a66bc5ccf1bbf985bb2b1aca92236f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72afc04e7c22ff6967b255960cf8fa23a3ce06c2b7d1be375088f3315002470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d774a224f07c7e4ad2144a6df48c39502100c3396e569e8f91c295019d0d799a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/libquiche.a"
    include.install "quiche/include/quiche.h"

    # install dylib with version and symlink
    full_versioned_dylib = shared_library("libquiche", version.major_minor_patch.to_s)
    lib.install "target/release/#{shared_library("libquiche")}" => full_versioned_dylib
    lib.install_symlink full_versioned_dylib => shared_library("libquiche")
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major.to_s)
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major_minor.to_s)

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
