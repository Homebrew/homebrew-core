class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.29.tar.gz"
  sha256 "dfdc0f339437345d9d5d8c2cb4bd43294c05821ebc8d5f0c9abfa4eec8f6c905"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "e1cbc3fe6bbeb42e4be4bed591ea19947e17180fd1b9339b54b22d5fca2f6243"
    sha256 arm64_tahoe:       "f0ad9c9ebb953ad5cf1e1cc4bbd2541dc40f190cc26307d27ad210a049eb8f22"
    sha256 arm64_sequoia:     "a1102226d22fd8768f6e5fdffb32b83c249d45cd6bbb7356f7c5235e57bf3193"
    sha256 arm64_linux:       "070825355117bcaa233e007b490e45f43bf9ec2f74715f7b2a7cb8a6bddbb1b1"
    sha256 x86_64_linux:      "464438b7230264085f495d22fdff402e5ec19fd5e8725901dfd786177cfc2a18"
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

  deny_network_access!

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
