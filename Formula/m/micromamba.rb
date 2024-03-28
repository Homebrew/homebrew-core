class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.5.8.tar.gz"
  sha256 "4ac788dcb9f6e7b011250e66138e60ba3074b38d54b8160b8b6364a408026076"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ef4289ffad79101e76c0371596018c0124f73149342f50258712b4cb9bf8fe0"
    sha256 cellar: :any,                 arm64_ventura:  "0c000c017074edd8d65fd17aea263704179eb9e64f59813c045df551b921bfc2"
    sha256 cellar: :any,                 arm64_monterey: "81cb206e47cd4a808a5fcc59f731a8b1f765b81fc167adb759c6da32de9ca82a"
    sha256 cellar: :any,                 sonoma:         "c71bb281bc24b7ad0822832a012251138c486288c8ed9a6b7fd1cd235317918f"
    sha256 cellar: :any,                 ventura:        "744fa02ede2eb15a615cfacb6ec89d4b9ead56769aa92b2e83cd48deb8808355"
    sha256 cellar: :any,                 monterey:       "52df20697a157981f67ac509a19c8a52ee9909e9c43f0880782c0e5df033c915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436d642bd19e6e4e702aa5824d683e886f676edb15f5a3846222b5ddd0bde213"
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
      url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-121.40.3.tar.gz"
      sha256 "bb972360581fe5326ef5d313ec51579b1c1a4c8a6f20a5068851032a0fa74f33"
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
