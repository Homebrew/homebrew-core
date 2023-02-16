class Killport < Formula
  desc "Kill a process running on a specific port"
  homepage "https://github.com/BalliAsghar/killport"
  url "https://github.com/BalliAsghar/killport/archive/refs/tags/1.0.1.tar.gz"
  sha256 "a04c9d71c1def96d1896096fbe2e3d1d5905ecfdef4b10136330f1f824177f7f"
  license "MIT"

  def install
    bin.install "killport.sh" => "killport"
  end

  test do
    assert_match "Invalid port number: abc", shell_output("#{bin}/killport abc 2>&1", 1)
  end
end
