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
    sha256 cellar: :any,                 arm64_ventura:  "34c49e5953ba750e7a1d920aa125caf8944965e35a6a831eea9590a2d962bb79"
    sha256 cellar: :any,                 arm64_monterey: "564303c0497bcf4764334ba751a105427e23d83b2ffcdad4204fe3f4f02bbf73"
    sha256 cellar: :any,                 arm64_big_sur:  "5006da53d4a01d66414b71a6e0cf4ed70758c78fc3d8e22cde412517c2843ff3"
    sha256 cellar: :any,                 ventura:        "5cd419a7df6ef506d7f6a6dda48c8d39c4f8dbfe6d67f556b5ed9b9558c4eec4"
    sha256 cellar: :any,                 monterey:       "56b5aa1f0fa369a9376b8c8cbc349c5cdbbb8e59a9ac952c6cba92e400559bd0"
    sha256 cellar: :any,                 big_sur:        "bcf66bf9b1504317d5463bbb9cddace8ac6fa56ac34b52f0145afbeeb8633a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb039819a0dfe93f04f57e4cb60c4692cad62b3b4bef54ebadfe28efc5da7570"
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
