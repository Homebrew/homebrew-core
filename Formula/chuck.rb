class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.4.1.1.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.4.1.1.tgz"
  sha256 "4459ee6f151da72dcde1525e0afe05329d61086356b168ecfc0bc3a570290f63"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2893bcb6afd2112930d50209b946675ed01e6e8371e84d8c8308f64626b66897"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c6657a513369a6afc2d1d0673f84df3864a7583f80799e9e392b374282fbe90"
    sha256 cellar: :any_skip_relocation, monterey:       "e42749e3f7fff4b65ab5f584bc86dc880c9407c881cd123f77335fee7cb50a41"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b7391e0b40562151469f0f2b62f30bd084c428560fa4f68e746f00d9b022060"
    sha256 cellar: :any_skip_relocation, catalina:       "8ecc0424bf308689a031260e8bf2f2a280812e5d59d403f30098e344df326bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "815b5ddb364f46e50da89327eecac55113bb7ce123a1dbb2959c79d953c51965"
  end

  depends_on xcode: :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "osx" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
