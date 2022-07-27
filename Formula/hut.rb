class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~emersion/hut"
  url "https://git.sr.ht/~emersion/hut/archive/v0.2.0.tar.gz"
  sha256 "2a4e49458a2cb129055f1db3b835e111a89583f47d4d917110205113863492b9"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~emersion/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfc5ed449fd04f519a390e2dc26410bbfd2c7e3f6c126a3e7de1a0441deaab59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1341ff46e755f2dd33ec3125d5c0ba89162a9b0414ef13548936be1c836fec2"
    sha256 cellar: :any_skip_relocation, monterey:       "442565002fba9b989f0a3f3b5de14259acfd8f6bcbb1ddcf196b7eb21769cf05"
    sha256 cellar: :any_skip_relocation, big_sur:        "229565a85bb337f627ec70c9984b675e0c54c1c2e8b7cd81ebf9a3a7d3f82f37"
    sha256 cellar: :any_skip_relocation, catalina:       "e1a84a343f7961cffefaa7107bcdc40a9a85ea13b99743e8ffcf7ef7aaf70cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30c5343766e55c828b77d83a46faed7ee68881e21268005e0267ca00701372cc"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"config").write <<~EOS
      instance "sr.ht" {
          access-token "some_fake_access_token"
      }
    EOS
    assert_match "Authentication error: Invalid OAuth bearer token",
      shell_output("#{bin}/hut --config #{testpath}/config todo list 2>&1", 1)
  end
end
