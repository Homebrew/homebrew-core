class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.11.1.tar.gz"
  sha256 "3cb82dc77c51293961f77d9e3f20b0b7e30b8165fc89461b37ac900a801d5ad5"

  bottle do
    cellar :any_skip_relocation
    sha256 "772c089bf5a99dba535e368a69a0ec4d738d786282bf52b180036f02c28699b9" => :mojave
    sha256 "b42f39865281f48c282522e4add060419b1a2793bcff29e11808ca5b66ee2de1" => :high_sierra
    sha256 "a96df7cb136db3415d16e2402d53a005f52982a2cfdc7c7d581a06e097e7c0a9" => :sierra
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
