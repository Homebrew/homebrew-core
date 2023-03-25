class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  stable do
    url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.0.tar.gz"
    sha256 "890f37e7f84e81b85976d0a26d171406dbbbb02416efcb95bda9f263e10c21b4"

    # Fix "error: chosen constructor is explicit in copy-initialization".
    # Remove with `stable` block on next release.
    patch do
      url "https://github.com/mamba-org/mamba/commit/bc7fa860c982c796f3c35acaa011304128bb4e62.patch?full_index=1"
      sha256 "16d1e3052d3a07a8951c918535ea0de8fbba53b7ded1145289253c4f6beb6e5a"
    end
  end

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d214fa090a7a00e9fa657b33caa9bf2c17cbe77aa2f500c2710758930d899e91"
    sha256 cellar: :any,                 arm64_monterey: "13bf833247cbdeb405278f7246df12fe9068989d890552db7f7a733d4866500f"
    sha256 cellar: :any,                 arm64_big_sur:  "c7bf3df72364c9cbed2c9f31587307a4bdd1adae9994fe47f72ee9160a51709b"
    sha256 cellar: :any,                 ventura:        "43e247ef66ba6bc2084dfe207aa6efadfcab8bcffa6db7c5526e3c8aeb94e7f4"
    sha256 cellar: :any,                 monterey:       "37a3d874465ef1afe1d57c6f8a764a926a0225a7afa715af24954fa8b0bcd0fc"
    sha256 cellar: :any,                 big_sur:        "326bfd5f58df2c76d11952ffaa64b6e9e9e2f08ee6b37941d5ad0fded9f58c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae05efcd71519e59eaa4ac78159b8f2c7224a684028b0f4a7921210858271440"
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
