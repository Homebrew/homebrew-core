class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.15/libmikmod-3.3.15.tar.gz"
  sha256 "dc27b338154b8f88dc9e6317196d42c6abc13bf63c4e055257a18d4e38e1afa2"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libmikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a403bc3f03367c11686b1997c9c75e39e0cf8212bdcc43259e9088cfb030ca2a"
    sha256 cellar: :any, arm64_tahoe:       "93feeba59b9c835dfa2d99f6f6291cbc02a7c8c78294efe4cf1ae4353c6c2682"
    sha256 cellar: :any, arm64_sequoia:     "18ef9d2a292570ea261d4d048e556beff2c805a412083357fdd0e816be7f6ce2"
    sha256 cellar: :any, arm64_linux:       "0e17b1a71ec3de3a7e78c9d84cc85c05080374a0f6b1185299c0260e9f1a08d0"
    sha256 cellar: :any, x86_64_linux:      "f9566137363514847165e312a0892b6f67a722a6de9946ffb143a452b50b4d45"
  end

  def install
    mkdir "macbuild" do
      # macOS has CoreAudio, but ALSA, SAM9407 and ULTRA are not supported
      system "../configure", "--prefix=#{prefix}", "--disable-alsa",
                             "--disable-sam9407", "--disable-ultra"
      system "make", "install"
    end
  end

  test do
    system bin/"libmikmod-config", "--version"
  end
end
