class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.1.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.1.tgz"
  sha256 "cbb8b417513c7224ddf49391f97901e8c2923bd3ac1a3fa8f7cd3046eb0362d2"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c714b6ed8d61b519e63ac596c6409b8ae4e43f0b1928a2ffffc010a019686ac1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "539e6bd540c696d9ea5ec2eec3a0daa2846dcd8375b540687e01bdbec54cd0b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea4fd062e986cab73d0ce41e64b80dba3ac82b63561361e7fcc72f5bee7606d1"
    sha256 cellar: :any_skip_relocation, ventura:        "a1478446626dfae2db5b4e11094667fccc0fff2456ff498e46dd61ad64c5e76f"
    sha256 cellar: :any_skip_relocation, monterey:       "cb3210a14d6578e6d042c6d91495f449270c6b656f1a9871c24083e24058fbff"
    sha256 cellar: :any_skip_relocation, big_sur:        "df7803eef380862c3e6d199d72cbf3002c65578a230894764e0c81eaa999d6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0243925e68ae353d0a873566fe63a96c90e7d347d0aae668e434b417958e0219"
  end

  depends_on xcode: :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
