class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.25.0",
      revision: "f5ab8433f7286958bc0009d2b70cf545b0562641"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f879eb4af67d14fb7d38afc9e489801843a5982c85fdc39c29eb8eb08f54db6"
    sha256 cellar: :any,                 arm64_sequoia: "89cac302c9aedf23a1c338fdc8a49bff86c0c3e90a554dc56776686eb37fddac"
    sha256 cellar: :any,                 arm64_sonoma:  "fc065c63c14b11498ef506259477b1468f25bc737433417efa7e91513afc0a75"
    sha256 cellar: :any,                 sonoma:        "c21e4a084adbd1facf7cc2b9cc52ee5b4bf3828f4593a23f3f23835478608a48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d40c69e2e5cdd990d8fd65aeb29d6c5e4b73cafb4cbe34e34965af813f62df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39559e643d184dde4dd5471405c5a57c96204c2188033fd043c2d8c3ee63cfa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

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
