class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.29.3",
      revision: "55886df3be579579207104c8e645825b6347a209"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3ab6bff012a2e2193d30e5b8b54d04b5eea7388820c26aa6da87211cf8b69f90"
    sha256 cellar: :any, arm64_sequoia: "f0081d3e1d456d15aa0bc3b9d56d21ab3a56242dc11f74cf60687163ce2d259d"
    sha256 cellar: :any, arm64_sonoma:  "3569f2d7dafee62ea8f556cd716a9267831d308a2f5e51d45e52b0edff4edc89"
    sha256 cellar: :any, sonoma:        "9fa84c7899f5c11116449e48ab011f28951b64c3c66caabed2465e7b77409218"
    sha256 cellar: :any, arm64_linux:   "e69a1368b2e9826ffa0b499171b356febc2cdd94ce73de4d031abaa38749f966"
    sha256 cellar: :any, x86_64_linux:  "b30ebb2fc9cfb15d619925f2927dcee1cb726b9d82ec01aec86191d988fb3f4d"
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
    assert_match "your browser used <strong>HTTP/3</strong>",
                 shell_output("#{bin}/quiche-client https://cloudflare-quic.com/")
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
