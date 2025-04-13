class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2.1.0.tar.gz"
  sha256 "8e8dd36a6d974a41d3bcd498f0b4f38092b25ed372d954e1721073e49fea9466"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e469a3ad98774b0eacb9916f5ae548e4ecf74d97d269ce2559f5e5f4ed5331d9"
    sha256 cellar: :any,                 arm64_sonoma:  "dedc01f2430fe42bbf1fd340822f66e7e395dbdc6f550351e5d39f5c90a92e48"
    sha256 cellar: :any,                 arm64_ventura: "ebb69f8955ff511698395a8fee2d0cd20ca3d0b5c55a9c4c320a6e513a9eb8c4"
    sha256 cellar: :any,                 sonoma:        "b294de2c6b49441b873e3dcd57190f50b46486930ac6363e89d2564d91280632"
    sha256 cellar: :any,                 ventura:       "8d57f8b6100464476136b52dfbe5e6325074c1fe98d86d3bba9fc5d8bc643f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b29ee28100a8635e8ed2adafaffee96d8495eae164e8f491e109b62cc042e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4fe02950bf7530b824cda25d3a4f5cc905a9bbf997f0ba446d0e5e6b3a5a49d"
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
        #{opt_bin}/mamba shell init --shell <your-shell> --root-prefix ~/mamba
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
