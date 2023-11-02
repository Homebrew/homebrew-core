class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.5.3.tar.gz"
  sha256 "f13e6e31279a8b526af63d53216cb6582fe0e4989d084260c24b0ab35de58dce"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77afa79e9475e043ef929309f67aa5dd5afcdb398d37e95ba5b5f6ade38517d2"
    sha256 cellar: :any,                 arm64_ventura:  "f65094c542be593ddac08150b03fe0002d826e92ef7ecd9386390dba3eb60b1a"
    sha256 cellar: :any,                 arm64_monterey: "c7d47cec7fd32d8c74e64b60d97736ecb9f7aaed27a14875658382140aeff410"
    sha256 cellar: :any,                 sonoma:         "5e5ae19517b95c0260929f829281989b3e84ffe24e111624ab76d55fc99cc953"
    sha256 cellar: :any,                 ventura:        "063e337a6ac7ce2dee74849d3ba0aa30ab3066f5ef2d37b830f5f002a0991049"
    sha256 cellar: :any,                 monterey:       "8936706a3609d035276869df46b7efb3ecdfc3b168121e22897c94672b65279c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f97380ba2cd21fee2ebfeefb48d646cc2436fb8c9e29ab95ec99ed34037cc40e"
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
