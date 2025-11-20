class BowerMail < Formula
  desc "Curses terminal client for the Notmuch email system"
  homepage "https://github.com/wangp/bower"
  url "https://github.com/wangp/bower/archive/refs/tags/1.1.1.tar.gz"
  sha256 "4c041681332d355710aa2f2a935ea56fbb2ba8d614be81dee594c431a1d493d9"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/wangp/bower.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c529955bcdd18e610441bd154d41cdbb03e164ea51aee9be99db4d4fa388553"
    sha256 cellar: :any,                 arm64_sequoia: "d47f47f021948b197519c8153299af29c6daf61303ec3271202a3db295d778fa"
    sha256 cellar: :any,                 arm64_sonoma:  "1b29ffd00b810534072cfb133481e8f56982ae599c14b93b03fd41a6c01b4511"
    sha256 cellar: :any,                 arm64_ventura: "09f3d4499761c4070ba39bcd3fe811087e8be0e87e393aea012ebef4375d5d9c"
    sha256 cellar: :any,                 sonoma:        "5def685cc6179746680820800b1f8d9639c59624b12f2e2f50bbe976fc7171d8"
    sha256 cellar: :any,                 ventura:       "7f687a08815bb53a12b385f88278e82f1e47adb7105d7d3fbe40dbe2fbb934e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e14703850f860c54de0e5e13c331e6e267bb001e90893d0079f31bc319ce90b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66cb33b65d91e09351fbc8b01b884bee0f70737756666cbfd7f93057d746954"
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
