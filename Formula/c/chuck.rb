class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.1.0.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.1.0.tgz"
  sha256 "28989b36624848f6a18883d12b757c7c623338f066b16618960efdf1cfa7588b"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9fa130b2e95977bb935dda49a9fd442eb36a1bc9b8c1662466fcdd9643e884f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c37b3b7df116434791aacff0eedb77bfb54c61b8a0da58f6760ac574860c00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47737b4cc49bf0e27f6cdc169ac08e9530a501a26bcc5189d3730f0d11c55e75"
    sha256 cellar: :any_skip_relocation, ventura:        "8ad2e3a5703c0b958fef4f2206d21c57fd58498ae9a6e0e4ed786f34f64e260e"
    sha256 cellar: :any_skip_relocation, monterey:       "1c7749296fd1865d4a0dd11902280d8c3442b587949678e5144b1533d750cfb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "580f0f48fb45963f3faa966a5783bb637f15f4d6e7fb54433004bdcbc89ede15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adbef7fc6e38830ac949416e71d196178e035c5da4b9d4858156c08b38841b43"
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
