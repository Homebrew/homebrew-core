class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.4.2.tar.gz"
  sha256 "4b5ff1ddf543d46610ccfa510689f2c11b32eb7561bf76815da853e6f0dd6bcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "49a7f650761fea0f964bc4542c745ebf4ee80325f18e1c666c352fd36a9b03ee"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
