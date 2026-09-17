class BrewNew < Formula
  desc "List Homebrew formulae and casks added within a time window"
  homepage "https://github.com/falagutera/brew-new"
  url "https://github.com/falagutera/brew-new/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2585a931e5401788439d2f9f43a4e1d5ab1ad56fd46bc1a7d31b84e0a7a02e65"
  license "MIT"

  depends_on "jq"

  def install
    bin.install "brew-new"
  end

  test do
    assert_match "brew-new #{version}", shell_output("#{bin}/brew-new --version")
  end
end
