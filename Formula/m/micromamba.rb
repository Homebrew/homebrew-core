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
    sha256 cellar: :any,                 arm64_sonoma:   "2165f5278d308d5f84f72b613863aeb1171150468df7780d582a112b4f1dcdcd"
    sha256 cellar: :any,                 arm64_ventura:  "2351b8451140bfd3edf6ad0e84d80fe39109023db8522934a0b457fa1a099988"
    sha256 cellar: :any,                 arm64_monterey: "0e7820de14d0cbabbbd688f821ad6699473c56fa85b16bfac5e56da081c14fab"
    sha256 cellar: :any,                 sonoma:         "fba47ea65c445f83bf94d9cb531c662d39646449f5eb2d4c270fa94dd449aef5"
    sha256 cellar: :any,                 ventura:        "15cb8d0dbb70f9a25db6e61d656babb928cf0e9bda7e0eaa3fd4502dd6ebbbcf"
    sha256 cellar: :any,                 monterey:       "6b8af8500dbbf7e8134a552710a81b1a7e882514a2e8773685534373b7082f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e1f871cdf482068d6116877cdfb004aa7bc221be30638b092555681b0ede34"
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
