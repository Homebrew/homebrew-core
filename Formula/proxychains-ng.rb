class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/archive/v4.14.tar.gz"
  sha256 "ab31626af7177cc2669433bb244b99a8f98c08031498233bb3df3bcc9711a9cc"
  license "GPL-2.0"
  head "https://github.com/rofl0r/proxychains-ng.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "3d9160bad88b034c0cafa375ce9c8b0f1ad727ca13952ce6622c85e23b3c28c9"
    sha256 arm64_big_sur:  "389c32c6e5a4a5226812a2b0136ec040f909580b144140594445327e2fc2ebbf"
    sha256 monterey:       "63b4f0288b83e6b0cf9ab1a340d5196606c54bca403eaf29930cc315e7d2929b"
    sha256 big_sur:        "168ca0ce8129eb8739bebf9ddea8cbc7ca594a18ec96c3d70a5e9a5868e3b7d8"
    sha256 catalina:       "1b8b781209633d9c4c45249b78865311e9853c36ba8522146a95cf4793d166b1"
    sha256 mojave:         "4b41340fc2a68c579b3ab30affbe82f9be545537f727507d19977b1b67193a96"
    sha256 high_sierra:    "42ba51b1578ff901987212d74e8b3a83ec6313f5ccfe3d554a9b32766f9b65c4"
    sha256 sierra:         "4c8e8c69bd10529a33b3f70e1a55504f79e3358fe834d521c95adafb2f4eea4a"
    sha256 x86_64_linux:   "017e3132cf30e9d01e736d96e17201671cbf7bc3a802a7c842e663b36082714d"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
