class EaCommand < Formula
  desc "Ea: make your CLI output actionable"
  homepage "https://github.com/dduan/ea"
  url "https://github.com/dduan/ea/archive/0.1.0.tar.gz"
  sha256 "269d57cf78645bd2b238bd3dbde965c05d1be631bcaffc354d9fcff4c77e06e7"
  license "MIT"
  head "https://github.com/dduan/ea.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("foo.txt", shell_output("#{bin}/ea run linear find -- ."))
    assert_match("foo.txt", shell_output("#{bin}/ea"))
  end
end
