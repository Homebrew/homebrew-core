class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.13.1.tar.gz"
  sha256 "22e75ba7d76aca157479bd7958650d4f0aa87fafbbc333f030783898592b73e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "1aaa6c35387434cba9860c869e0894966ed2496d711d6e3df404cd53236e5e02" => :mojave
    sha256 "b82a076649652e82d58104d521a2cb675508288468c5ae9869987507aaf4c0d0" => :high_sierra
    sha256 "1c283a629ce47f1bc621b513279a3c53bbd09ffe447207d1e2353ac51d71870c" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "bettercap"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    bettercap requires root privileges so you will need to run `sudo bettercap`.
    You should be certain that you trust any software you grant root privileges.
  EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end
