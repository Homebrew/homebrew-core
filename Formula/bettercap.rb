class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.11.1.tar.gz"
  sha256 "3cb82dc77c51293961f77d9e3f20b0b7e30b8165fc89461b37ac900a801d5ad5"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac3121ed8ac3487ffcf1b8e078f0f7f87c9b77bd7f6784010cb945a4488c7df1" => :mojave
    sha256 "d65c13106e6890914fb701af8ed3ed4b063ac90cd856e80059d1fa5fe101f1ef" => :high_sierra
    sha256 "52a262a0be1db586b60354b0777f225d52488af1fdcfd987b5b2101fcc44179a" => :sierra
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
