class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~emersion/hut"
  url "https://git.sr.ht/~emersion/hut/archive/v0.1.0.tar.gz"
  sha256 "5af8f1111f9ec1da9a818978eb1f013dfd50ad4311c79d95b0e62ad428ac1c59"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~emersion/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e65754e2e59cbfaffec7702d6596a07b8d731b41407bcd51e3d6de4a4648a7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7619b587d4b51e53e3c4dda73e0802b1cd4402c8413f7c4bba0e07f71004b36"
    sha256 cellar: :any_skip_relocation, monterey:       "e718ab23294885b43bcf1bc613ebe8f8fe409841ad7b997c656bd98b43b8461b"
    sha256 cellar: :any_skip_relocation, big_sur:        "56d374f3710cf7c23a47cd23d29432da709538845f0ae40dac24d2978d506b73"
    sha256 cellar: :any_skip_relocation, catalina:       "89d64faee93e1c33b1b0556ce67cf10500890d65b5b1e90b6d5a2a95e4ffe243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58268d892d191366f05bea4d8a89b84e0fdbb221b6756d35c94efc55577a2c80"
  end

  depends_on "coreutils" => :build # Needed for GNU install in 0.1.0, remove in next release
  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "INSTALL=ginstall"
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
