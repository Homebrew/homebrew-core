class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.12/libmikmod-3.3.12.tar.gz"
  sha256 "adef6214863516a4a5b44ebf2c71ef84ecdfeb3444973dacbac70911c9bc67e9"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libmikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bcca5107fd327242b0ce2b1ad1a8d5309e24ecd2ff87bfdb73670444879830fb"
    sha256 cellar: :any,                 arm64_sonoma:  "f9852b8403459b0e47c8bd1da5a2aef9fba3ee7e6919cc61f2451fab1cba06fd"
    sha256 cellar: :any,                 arm64_ventura: "8f0297731ec4cae97562b8d748bf007817bc25804b135c19e5f0639d917b6c17"
    sha256 cellar: :any,                 sonoma:        "09db4f2be20a851a09ea6821f6913cf799a0414f44ac9fdd1477d0f4425378cd"
    sha256 cellar: :any,                 ventura:       "6fd0a06c81b3a27e4acdd9618d0a5b01e64caf4d20abcb5af660fe85f7df06be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5603dcd37819b47c6f9fc36dc60d9fb269412ae0b6bc941b89bd38092fc7fb9"
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
