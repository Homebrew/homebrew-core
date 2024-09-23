class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.5.10.tar.gz"
  sha256 "38ee4658f66c5e4bf2c33cd3c9c0ebd01fe2e3a6da6ac619cc4702a9072dcc3c"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "86b76aff2d2197307274cdafcbebc31c84e7ba98859a6b5aea72394b13deee53"
    sha256 cellar: :any,                 arm64_sonoma:   "88b51ba79028340a5f81ce13ca35446895e29c7b8a4b2ed3442b3fcf95c69bd6"
    sha256 cellar: :any,                 arm64_ventura:  "1789a8f976fe30c27c052c62e81d7a6bec1cfca9a7b38ce26c27548535cc6b98"
    sha256 cellar: :any,                 arm64_monterey: "54cd8bafa37922abb9fec44eaec97c428d151bd5f79f9f88a0e024d320314957"
    sha256 cellar: :any,                 sonoma:         "767711d0140c57c0382b7c32d3be464fb135462988447d3091cb96793c96115c"
    sha256 cellar: :any,                 ventura:        "b29817db6aa5e8fee0d4ad73c21243b9d528577ea5cb02b1d14e34c8ebe70ff9"
    sha256 cellar: :any,                 monterey:       "09e134355626d38fb15c547208cf040f18a20dc2b031192e724335a0c477268f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d26b77759ba7012952ee52ad0b02374042981ccb1f0abe0556fffab535c00a39"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build

  depends_on "fmt"
  depends_on "libarchive"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

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
    system bin/"micromamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/micromamba run -n test python --version").strip
  end
end
