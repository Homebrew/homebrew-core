class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.16/libmikmod-3.3.16.tar.gz"
  sha256 "7b24e41468b0dfe7fae1104ae6a0d7c52e04a65e1851b268c7074e4d06685a53"
  license "LGPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libmikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7381c5f385a259badb7c64f91e8f0980f74b5d1bd659e2a7c3b071e79b0b2690"
    sha256 cellar: :any, arm64_tahoe:       "6ea51e8c9075edbd6c69609a1cbbff78dc255ebf65563eef342bb39ce1508b85"
    sha256 cellar: :any, arm64_sequoia:     "01e0d8558366a914db9912127103d31c30df44667eab6bbaedf98939014e8eec"
    sha256 cellar: :any, arm64_linux:       "c2f86b6d443462a961be14eb86fae10c310820aeb4158c0b37a26949579800c9"
    sha256 cellar: :any, x86_64_linux:      "232cf91bec8db7f780a45ce8753662a523f0ce8a6b5114009ddb78cb379ffe05"
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
