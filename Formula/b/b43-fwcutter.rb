class B43Fwcutter < Formula
  desc "Extract firmware from Braodcom 43xx driver files"
  homepage "https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.html"
  url "https://bues.ch/b43/fwcutter/b43-fwcutter-019.tar.bz2"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/b43-fwcutter_019.orig.tar.bz2"
  sha256 "d6ea85310df6ae08e7f7e46d8b975e17fc867145ee249307413cfbe15d7121ce"
  license "BSD-2-Clause"

  livecheck do
    url "https://bues.ch/b43/fwcutter/"
    regex(/href=.*?b43-fwcutter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5e27ebebb8d25a8d3c1ddd0e03b4a9f174117c1cb977c590b1c5300f5b45629f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "feebcb5d44b93e56fb3057568f06a25214d0c0aa2b03c48c0e8a068ecf5a1986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de90ea58c943e6a3a4da88710cfc5b1e29e646e1033ca280dac8730184346572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4d24a045df3b788ed629cd5f67509f5a0c5bff70fcd213f72107c2db166e3d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22dc022f54852b54e28b799378fcbd2ca877eb815332d90199881dbfe291d84b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c68725ddd4ab0d3467c8eab623682712e51d180e4517e1fa04518c0aac4c65a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c24cffe8c519050b9e9810e28038cb84815a5526089e5aa15f239c8061c131f2"
    sha256 cellar: :any_skip_relocation, ventura:        "5158aa819495b8aa8692bee35210299f865b62fb3cb4e559019290e1964b5ac5"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c8994d63b3a39547fc9675b60c163575b6c88d24634d6ef0c0f29ebf1dbecf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d71a9a74998af98e4593b5593ff415aa4e6f868a9fe7b7fa4814fd27a4b6652d"
    sha256 cellar: :any_skip_relocation, catalina:       "65b60abba52b848bd47386245505719c4c2218429719cf008a6720a4fbcac36a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "13ef19f39b23087c593c3f7b9c61e0eec77695230bd14018c4af95600f56450b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730c1aaf1eca6cdcc4abab681ca38e7629699e85ac20bb0082b15abbf317a5ca"
  end

  def install
    inreplace "Makefile" do |m|
      # Don't try to chown root:root on generated files
      m.gsub! "install -o 0 -g 0", "install"
      m.gsub! "install -d -o 0 -g 0", "install -d"
      # Fix manpage installation directory
      m.gsub! "$(PREFIX)/man", man
    end
    # b43-fwcutter has no ./configure
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"b43-fwcutter", "--version"
  end
end
