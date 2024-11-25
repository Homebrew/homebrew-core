class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-2.0.4.tar.gz"
  sha256 "29281fe9b8fa99ecaa01d791b00889fb953fdafa154bbdf877a0858044334439"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b5e5a63b30d9467ea04ebe0796b645a1e1096b179b9781b4d29740dcd0df9de3"
    sha256 cellar: :any,                 arm64_sonoma:  "a621633e464bfec93cee5f8a9ddd99fe8724d276b54bac749210522d8a8723c1"
    sha256 cellar: :any,                 arm64_ventura: "f1d82146dcc0cc466c314d97154c5b6351a9dbfeb82cf06f1fe7049f50b4b1d4"
    sha256 cellar: :any,                 sonoma:        "584d465c093c56765e48ae2c429477446bd1e5bbc0f2f5a01c0e4a0dcc1a9e7d"
    sha256 cellar: :any,                 ventura:       "1d55ba702f46821eb99e69c689a9326e36d73f65e8cf364b94d9dbd525368b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a40b04c2c699c85bd1fd7dccf266ed50d3d978ad30145e02e0c66255ec858293"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build

  depends_on "fmt"
  depends_on "libarchive"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "simdjson"
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
      -DBUILD_STATIC=OFF
      -DBUILD_MAMBA=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Upstream chooses names based on static or dynamic linking,
    # but as of 2.0 they provide identical interfaces.
    bin.install_symlink "mamba" => "micromamba"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/mamba shell init -s <your-shell> -p ~/mamba
      and restart your terminal.
    EOS
  end

  test do
    ENV["MAMBA_ROOT_PREFIX"] = testpath.to_s
    assert_match version.to_s, shell_output("#{bin}/mamba --version").strip
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    python_version = "3.9.13"
    system bin/"mamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/mamba run -n test python --version").strip
  end
end
