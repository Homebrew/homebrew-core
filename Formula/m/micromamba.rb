class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.5.2.tar.gz"
  sha256 "abb692e4b249d1e781e90c887d24eae0c97f80a74e04bdf722bc1aceff68765f"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f0ae39d544d02cc25cc37546756826eebf6fec2b581da6d25100ecb0b44a7a9"
    sha256 cellar: :any,                 arm64_ventura:  "b3d8c600ce5d12178dfb104caa5ab8bd7701649644e0de7fe1aa6aea249826ef"
    sha256 cellar: :any,                 arm64_monterey: "f888448b47973e5c8a61dbc1cc0c10652c65b88a79e72bc16a90c08fc9ee9482"
    sha256 cellar: :any,                 sonoma:         "97b6c5b02bb277d332cb0982ec7c61cef13a2f15123e137d7b83d434b8a8da8b"
    sha256 cellar: :any,                 ventura:        "93b061450c7e90405ec274b5f7c0093694e295d972f17b036bd7153451bc0b85"
    sha256 cellar: :any,                 monterey:       "246445073a5d43ea7f73a8b69d3150fdb2d934546c39da0a2b5077c0fa5358b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70624305b57fb363e334c35c0639bb7ad2b25d242edfd675f35d275807891326"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build
  depends_on "fmt"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
  uses_from_macos "krb5"
  uses_from_macos "libarchive", since: :monterey
  uses_from_macos "zlib"

  resource "libarchive-headers" do
    on_monterey :or_newer do
      url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-121.tar.gz"
      sha256 "f38736ffdbf9005726bdc126e68ff34ddaee25326ae51d58e4385de717bc773f"
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
