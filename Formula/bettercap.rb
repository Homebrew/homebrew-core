class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.16.tar.gz"
  sha256 "75291742df7ced2fc7daa445c87c90aecdd21249892bc6664a5acf2a50c2fa22"

  bottle do
    cellar :any_skip_relocation
    sha256 "61a4ac2ce8d3ad1745016353e9d784557837d74bac996b8ab7bac607581857e7" => :mojave
    sha256 "53fa23726f07591f31fdb123b2c52369f2118a6f75f8c0ee8ae81265a34c6c38" => :high_sierra
    sha256 "d7bce8c4d8a76ba63b50faffb84831c392d121a16da5789c7db48b77df9aa39f" => :sierra
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
