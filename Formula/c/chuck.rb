class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.2.5.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.2.5.tgz"
  sha256 "e5b604dfb303639392e15245f27dcba6514292b58d0c00b64b00dfa6a116ec75"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c17e1e6bfde23f5dab757502e8f1b1c3212e8fcecaa0ce82694491cf05c80e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "308cf5ce16e9c3a16eedfa835d990dcef16bf93412c7f94efb97ea3c8cfce9c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c55d357a5d147cd7b907096f69be83337d87a15a1342ac71fd8317c3d8e5b25a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6873d3ab3337ec5f0a657723b0fbf6d0117d41a37f60c7478b9eee57be6783f1"
    sha256 cellar: :any_skip_relocation, ventura:        "2390007e18a5f73fd88c183544ddbb223143df44c1a7e373f7c2b89937b1a447"
    sha256 cellar: :any_skip_relocation, monterey:       "ae5532853bd70bb832b9707499bc12b189bbc327745771bbf910be814cff5a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39c0fac876395360fcc3de2cb8cb18d75d6ccdbc969f7ade067ff2a08268cb17"
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
