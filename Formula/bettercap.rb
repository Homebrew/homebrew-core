class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.9.tar.gz"
  sha256 "3c44246d18ce417e9db920d9f5929e1a55f5f7c713b6e77bc41edd04e410579a"

  bottle do
    cellar :any_skip_relocation
    sha256 "586429477cb29a4947f2a2dff5727ae818957d330f78a8c28838f0c68fc9745f" => :mojave
    sha256 "9543e2e0ce043a3a36a27ee17db633a05b1183c4e159eb9ad06338e68e7d5aff" => :high_sierra
    sha256 "f84673840eebbeacc1e0e17ac6ce6467019373c8615120f5fe990aafdb059fda" => :sierra
    sha256 "6f0ec386ee44e427b0f95dc12c3f047c47eb6a1072501169df4529aef7f7af60" => :el_capitan
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
