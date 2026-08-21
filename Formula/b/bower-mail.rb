class BowerMail < Formula
  desc "Curses terminal client for the Notmuch email system"
  homepage "https://github.com/wangp/bower"
  url "https://github.com/wangp/bower/archive/refs/tags/1.2.tar.gz"
  sha256 "2b175a91b78483ee7648c39f64e09405885a88ee9144c6891c3e30de570a4c45"
  license "GPL-3.0-or-later"
  head "https://github.com/wangp/bower.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "15688f2f89abe3e60b32195e335c95d97e73cbc9739876f899be65c91b96ac5d"
    sha256 cellar: :any, arm64_sequoia: "fbdc86417de7facd93e10e042d97982c08100228b3078e49079ad791c8512f41"
    sha256 cellar: :any, arm64_sonoma:  "7d130249ab037a5b9c3bc19662f00cdebce599d0f8de25f2605c993eb1f0d9e2"
    sha256 cellar: :any, sonoma:        "ae391d2ef6b0c02ebc792e6af2bb0b7fbfb045b361f9cc9f15667583982475b6"
    sha256 cellar: :any, arm64_linux:   "dc046afc9b2768a72fecd8df04fe83ee4fd6f39ac15aea81cde89f8a638cbc9d"
    sha256 cellar: :any, x86_64_linux:  "db490cf9809299594aac16149a3b85e77eb1f7fafe4b6fe96859fe4f2886fad9"
  end

  depends_on "mercury" => :build
  depends_on "pandoc" => :build
  depends_on "gpgme"
  depends_on "ncurses"
  depends_on "notmuch"

  conflicts_with "bower", because: "both install `bower` binaries"

  def install
    system "make"
    system "make", "man"
    bin.install "bower"
    man1.install "bower.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bower --version")

    assert_match "Error: could not locate database", shell_output("#{bin}/bower 2>&1", 1)
  end
end
