class Pacapt < Formula
  desc "Package manager in the style or Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.13.tar.gz"
  sha256 "078596bcbf6cb5e50abdeae2cf057432bccda5c716eb48fefdeee8da04998b7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "123006ab10ad7de32a84401dd0dcb9fd87afefabd0ab24dfa1f19298a2e7a69e" => :sierra
    sha256 "7f6cffa5423937eadf3fa5ce19f1a579dd36394a30717514b245de18881940ab" => :el_capitan
    sha256 "6a08957b772fcf7adc3e15e03bfd94c25eb5e204c33ec2a3812c3a3c7977b691" => :yosemite
    sha256 "129d05a1bdbbc6f5b669bc3ae9d4750df51459b7689de480e59ea116b65705d4" => :mavericks
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
