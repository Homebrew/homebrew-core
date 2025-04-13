class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.24.tar.gz"
  sha256 "fd279bcd8cfebaba1c6134ffdc0b429e2cd0b7d8ece94037bfb57cb210564a5e"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "b5b39254b4b59cd02aa1927cb25cc0a6901e2b16bf639dde836fb37bca1d4a2c"
    sha256 arm64_sonoma:  "83e05fa276554e2b53ab24e1b5e30d47de3bf2919ad85db46b20a3d112b30c35"
    sha256 arm64_ventura: "06144c18240190fa7a935ab1dc2bac57cafe06b91a50c13611d8ea86415778ce"
    sha256 sonoma:        "aef75778f33b553af08d7914fea906e3ca69dd290b50b443d231e25683efa126"
    sha256 ventura:       "355fb3e707cbf890d51b1fc28e460c8644d240025dd4fb69a366925efb8297f1"
    sha256 arm64_linux:   "9b2a04064e2f8ebe41172a96f49db9d8a02d41418ab19e200eaf2e2fcbb8673a"
    sha256 x86_64_linux:  "d86b85b0bee2de2efaae1b5d9f5e0d85a37243413e8b178c8ed4f6d0d23d0c08"
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
