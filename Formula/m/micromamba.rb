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
    sha256 cellar: :any,                 arm64_sonoma:   "361a2e2650189720915c9657e0e310b14f9f1bcf4edfb114440a25d796822dc7"
    sha256 cellar: :any,                 arm64_ventura:  "05d7ceea3d891f01cc534916fcf233a4e6da9b33e535e44a1b641f7a387a6577"
    sha256 cellar: :any,                 arm64_monterey: "9c8707494179b24883a8eeb8c9db4c4ef661f22bf08338248786fe61b5ead79d"
    sha256 cellar: :any,                 arm64_big_sur:  "321c3190791095b4519122c8d07f122f8a43c1331b0c77c770898d746ce5b94b"
    sha256 cellar: :any,                 sonoma:         "6ed408c0d2cdbd367d142bc664b75c0a4aaaeae41a55481fea6d8cdc6657d449"
    sha256 cellar: :any,                 ventura:        "c088a31127397b7bc6e370860104535f0234cae6e4db273739370c1292ad7211"
    sha256 cellar: :any,                 monterey:       "3418e66338cea36d840e243ec75e7480ccf6c87005c628a135f8ba85cff74281"
    sha256 cellar: :any,                 big_sur:        "d219bd73cdd7a14b03ea76f00096b869576786e92cb9ccfe4d58ef8b7fbefeed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5610e98f240b575f687f25a702ff782de8e29524dc73ead0d7bef7c86c019576"
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
