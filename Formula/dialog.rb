class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20220728.tgz"
  sha256 "54418973d559a461b00695fafe68df62f2bc73d506b436821d77ca3df454190b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50af3ce2ebf8f0f6168d457b004a091e3268863f963adb5db5623420fb8046ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f92895a98040a2ff1a7a4cd1923ddf93130f84dffdbeb03ca1ffaef9c5f03c5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17723d341f3ec1609405e8b597bb87926da3d00ff208be14df87568f87c55caa"
    sha256 cellar: :any_skip_relocation, ventura:        "b6145eb65d40bbfa19392ece112deda6afb1686e5315ca7970360998bcce7930"
    sha256 cellar: :any_skip_relocation, monterey:       "a40c13d04bbf4039619301faad320cac8691d66bd928c0b5976ef1891e33e92d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4187d20252fcd775d57ff445e6d79ef7e1a92ee603c80ebee3c4522450f3c65f"
    sha256 cellar: :any_skip_relocation, catalina:       "00495c5134b064176cb0937d1f70d875fd32e5bb909cf0ede3fdce51157368fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86b29f26a7abb8c407a12e2c4d98d021568089c6c83b0ff22282b434eff32dda"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
