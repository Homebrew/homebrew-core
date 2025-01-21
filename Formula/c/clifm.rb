class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.23.tar.gz"
  sha256 "5209a7286541bebc9649537abe9dfc1cfa76c6aa317afb5a6ed87270c1d069aa"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "4f35bdc52b5ed13e9f90ba8e0f998f4af53db6c610c60453d73415d32ce7132e"
    sha256 arm64_sonoma:  "e43104f389b9f11c9c8d34519485e2c309c86263c74d97e60eb0107b4380414c"
    sha256 arm64_ventura: "ceb8c827b865c041b9828c9fee2aaba3dbf16841014fb981331020648776999d"
    sha256 sonoma:        "785ddb14722b1491dae4563e8f390508c1854fc1c91315cf698d85c5aa878af2"
    sha256 ventura:       "a1bfda9475b9ae58baac4aae18eabeb07f27bd5331e118920e650a4723e06588"
    sha256 x86_64_linux:  "3ac06c2adfb00491eef72bb7e209f1d1e9866146810ed9e997179d1595e90be0"
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
