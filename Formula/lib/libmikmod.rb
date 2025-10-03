class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.13/libmikmod-3.3.13.tar.gz"
  sha256 "9fc1799f7ea6a95c7c5882de98be85fc7d20ba0a4a6fcacae11c8c6b382bb207"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libmikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d653577b59cde3b147bd826c620943aa4ff7a1e340a04adeafec2f06018eaf57"
    sha256 cellar: :any,                 arm64_sequoia: "c884c16332ab7a4e5f0885ac41dc8465cad460a8d6d0b16de20df05517b0bd5e"
    sha256 cellar: :any,                 arm64_sonoma:  "9d5c7c973d4608a40a9936b7f6dffc655f2347dc039954db9a1a8a5e55a88000"
    sha256 cellar: :any,                 arm64_ventura: "ff1c9e7e9a3f65e4a087c5acb0e6240be6dffe6fd5fa7b9aa2b3f88968152918"
    sha256 cellar: :any,                 sonoma:        "8ba4615681cd65abe541b9f271b9044f0f9973fd3ca87ff4b0f91a11272ab741"
    sha256 cellar: :any,                 ventura:       "ebdda328138ed7cf1ce442eb573cbacdac9cdcc4073167137c6a0bb7d7972a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84447d6469b55c513e2151b9bc890ec99cc01b964db194ab45c31adbc04abd26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fbaa53e60245b70b5b025c64da98ed014dd083a5c1ad77259139a51df77c216"
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
