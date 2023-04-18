class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.2.tar.gz"
  sha256 "dce034908d02d991c5e9aadeb9d01f139d027ba199aaeb1d47d543e3f24895d1"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e1c27038823628bd723d23bf02c1002dc70e18f599728fbe81e3a9c737d3b3c6"
    sha256 cellar: :any,                 arm64_monterey: "2b44218ec7c111382c68e3229b5ae97ff639f99eb1a731243fdfe9b8e87deb04"
    sha256 cellar: :any,                 arm64_big_sur:  "3cbab593cf69fe78d3e6318cd8964a91f65f89a3ecf7151b3ef16de3d64dbee7"
    sha256 cellar: :any,                 ventura:        "e69749479ad0f6da36927965842c2d976ff7bb0e813a4666edeade4c85eedeb6"
    sha256 cellar: :any,                 monterey:       "4acc27c69b5442264d48e1c4e3370398d82e28f5a2f1d546c67e2bd28f7fe3bc"
    sha256 cellar: :any,                 big_sur:        "e5b302bfac834bc8c1a647ac5a98d50566e64ef5b63d20f12e4dc7bb01b2b628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b6082f9002e2d0efff17df022e4a8d1c53261c2f52970724280eecd8d6d98aa"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build
  depends_on "fmt"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "reproc"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # uses CURLINFO_RETRY_AFTER, available since curl 7.66.0
  uses_from_macos "krb5"
  uses_from_macos "libarchive", since: :monterey
  uses_from_macos "zlib"

  resource "libarchive-headers" do
    on_monterey :or_newer do
      url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-113.tar.gz"
      sha256 "b422c37cc5f9ec876d927768745423ac3aae2d2a85686bc627b97e22d686930f"
    end
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    if OS.mac? && MacOS.version >= :monterey
      resource("libarchive-headers").stage do
        cd "libarchive/libarchive" do
          (buildpath/"homebrew/include").install "archive.h", "archive_entry.h"
        end
      end
      args << "-DLibArchive_INCLUDE_DIR=#{buildpath}/homebrew/include"
      ENV.append_to_cflags "-I#{buildpath}/homebrew/include"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/micromamba shell init -s <your-shell> -p ~/micromamba
      and restart your terminal.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    python_version = "3.9.13"
    system "#{bin}/micromamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/micromamba run -n test python --version").strip
  end
end
