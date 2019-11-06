class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.4.2.tar.gz"
  sha256 "ff59e9b1a5f049b7c5d8c309d99829a014d095153b453b03f6ab83dd96a538f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a34561d7223c424b6e0f537b4fcfe46345200b800a89bd09c380aca21c8bc2a" => :catalina
    sha256 "572ec7a9d8ff9a4401901f686e12a80755d41445096255874b638f6985805d6f" => :mojave
    sha256 "572ec7a9d8ff9a4401901f686e12a80755d41445096255874b638f6985805d6f" => :high_sierra
    sha256 "040769debe5d693492008f6e06c23e3dc09369ac5c7ed10fa2bf0715ae4eeba9" => :sierra
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
