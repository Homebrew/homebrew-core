class LuckyCommit < Formula
  desc "Customize your git commit hashes!"
  homepage "https://github.com/not-an-aardvark/lucky-commit"
  url "https://github.com/not-an-aardvark/lucky-commit/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "3b35472c90d36f8276bddab3e75713e4dcd99c2a7abc3e412a9acd52e0fbcf81"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c56571170906e43a64028e57c3d74309068be8ddc139a8ec41a099fffef7c31a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9239980fc34cabd2235d8e85dd01bdaff518aa92010c6a010fc3721cb943825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4142ce5e2266e26e3be3e3347f973a3c742231db25a1144cd97466a1d752128f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "987b631a1b4de35cde6109496d78f678df348a0e7bcd5d68a08e0ec4ffd90735"
    sha256 cellar: :any_skip_relocation, sonoma:         "fab07b3bd0bb22fb4d1bddeb041101a0aebf39966162254e7e87766c98cdb2b4"
    sha256 cellar: :any_skip_relocation, ventura:        "cda52467ebd9050c3dd693ea0a561ac183ea70ced7a636ca2c250bcffaa7e7a4"
    sha256 cellar: :any_skip_relocation, monterey:       "6534761e0409ee6b0feddbe9b0d7d6157a9d3ec4452a17c93dfbcb54b4635f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "668950e5f06bc9802221ab922acc18f56c512cd9d947ccfd0675348d620140e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779462c752d75cf65e3f301a14476f850ebbc058557795d17048a000d32f322d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    system "git", "commit", "-m", "Initial commit"
    system bin/"lucky_commit", "1010101"
    assert_equal "1010101", Utils.git_short_head
  end
end
