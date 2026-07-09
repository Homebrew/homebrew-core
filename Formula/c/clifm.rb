class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.28.tar.gz"
  sha256 "65ac33825fb55d6388c1044572e464a50ad367b607448774fb396d850b7c4420"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "8773b7edc529535c6c303c8f1904f3fa8a3d46c5e3d3f3399c59b83aaec81fc9"
    sha256 arm64_sequoia: "df873ccf50105c59a59870e045bed6ff27555973c6c05951ca4beb1be052191f"
    sha256 arm64_sonoma:  "6df2f1ba90f5b4ea8473979d4f70250284bd9c93523ea6001a59b6a02343ce5e"
    sha256 sonoma:        "a24cfccd341046be57b99427cb456342c0d22b73ea3d0c85885951b829b86858"
    sha256 arm64_linux:   "d00099c85729bde8558efd86578846065ab434b31c58d92b40304cd795561421"
    sha256 x86_64_linux:  "319a94323db425715ddbde68031da23f6e2649d25136297c251dbcd0b4143d48"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libmagic"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
