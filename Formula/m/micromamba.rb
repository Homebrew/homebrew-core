class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-2.0.2.tar.gz"
  sha256 "52a9ffe51d7da271cd4c5c200346f757531d9b41ef6a9ce9edc86891ce5520bd"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3bf5ba3e4fa863d6072c78c4229e533efaeda27137e78191c3c5d852470f46b2"
    sha256 cellar: :any,                 arm64_sonoma:  "01eed43203215173119a8280a7ed2f97417f09c236ac279d95ad94fe57af8fd1"
    sha256 cellar: :any,                 arm64_ventura: "273313c71f6212077cff10f6ee2ba00fe2d50056d356088935d38204bcf3ab71"
    sha256 cellar: :any,                 sonoma:        "e0d5863f983f062ea6e108d8258d755ad0fd28d9d5fd764d559b8ec46199aa57"
    sha256 cellar: :any,                 ventura:       "45a20d1caddf34134b10cd45b6af40a5db46787b44a5a358ba0cf306871a2076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3af94e30de7979583d176e00f31195eaebeb24fef85f3919923c7de5ead80fc"
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
