class Mpgtx < Formula
  desc "Toolbox to manipulate MPEG files"
  homepage "https://mpgtx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpgtx/mpgtx/1.3.1/mpgtx-1.3.1.tar.gz"
  sha256 "8815e73e98b862f12ba1ef5eaaf49407cf211c1f668c5ee325bf04af27f8e377"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/mpgtx[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)(?:-src)?\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e6a9e46221da11c97decd1340aa411ca181d6c0eb331470e61e5c08b96cf6823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2ad9aa8dd08b96ea82867c569333e92438e2e7131c287a1f4a2f9ab8be6a3755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82dd83969a60031ab766c86fa4859dad5fe9469f457f93ca034418daf00b8ff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9086ca4f3b6b2448255352f89972039b6695fead5f4a3f7c310b0c27fb6ad9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09eb55b5471006050d5a0d02a756c8474d2500ce289ebe8dfbe22a95cfbebc14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffab63d205a5b151099b5034943d1b34ef5802a4068c832c3da376f67b540745"
    sha256 cellar: :any_skip_relocation, sonoma:         "d72e98f7a717a312e7c328db019c13431cb5800f24e7ab36911a5a8e7f342b2b"
    sha256 cellar: :any_skip_relocation, ventura:        "50b17722b66bcdb43ba33472f34955e71625817238660626be12a2407ba0c9ae"
    sha256 cellar: :any_skip_relocation, monterey:       "d74d7e1c7a278e72e9b98afed71f019b51000784bd385450f88a4d879d1fff7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee222d4e5a24b91c13ae86e2e66291adc636d859f4b4c9cd7ba0944ffb629278"
    sha256 cellar: :any_skip_relocation, catalina:       "116812d4c0401a6ceeae3bd8bd0bc3f4870c0cac7f9ec166ceb97f5279c10d32"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c9c4e3ed17bf4c1669dfd9d61a3064ebe5e956325678c9820a7b840f6a093473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "133e123b7b8f9956959847378b68fc0c68f1e591209bb060ab7c7d024426f343"
  end

  def install
    system "./configure", "--parachute",
                          "--prefix=#{prefix}",
                          "--manprefix=#{man}"
    # Unset LFLAGS, "-s" causes the linker to crash
    system "make", "LFLAGS="
    # Override BSD incompatible cp flags set in makefile
    system "make", "install", "cpflags=RP"
  end

  test do
    system bin/"mpgtx", "--version"
  end
end
