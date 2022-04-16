class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~emersion/hut"
  url "https://git.sr.ht/~emersion/hut/archive/v0.1.0.tar.gz"
  sha256 "5af8f1111f9ec1da9a818978eb1f013dfd50ad4311c79d95b0e62ad428ac1c59"
  license "AGPL-3.0-or-later"

  depends_on "coreutils" => :build # GNU install
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
