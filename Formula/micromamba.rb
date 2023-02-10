class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.3.1.tar.gz"
  sha256 "af66b79bc6b9673209e92b6ce6e52a21a79c55e86960a9d5bb10691cf2b4e327"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a95ca7a0f74a2e0bee8ee9c72ecf196f3b5c9af661d8f5ca57e22686e25d6cbd"
    sha256 cellar: :any,                 arm64_monterey: "70e5737e192d685bcd2fdd1d5d647a10ef13d96d3e564ebcf795406c3ba007bf"
    sha256 cellar: :any,                 arm64_big_sur:  "0ef3edf33ed3249c347f1c8db2f77363db0da3a7ed15fab0ad972e9002e7c587"
    sha256 cellar: :any,                 ventura:        "f4080ec5170383bcb351c6df1c1cdc684613f5183eefd8e6555fd262a4da9219"
    sha256 cellar: :any,                 monterey:       "63b44c045f132fe45aafa4595a87e231e7825c949b6a203379cd978e275e96b8"
    sha256 cellar: :any,                 big_sur:        "a3a15adbd8e4c4bb3cdd911ff5dbe0a1639ce5ddc27f682480e8441b923b0d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b419e6d70b2bc9bd19877f156e8aef002eb3c635a16279f437cebb3951f7e818"
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
