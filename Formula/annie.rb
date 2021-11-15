class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/v0.11.0.tar.gz"
  sha256 "6b3e005b6bc2519e2c7b4767fcf66a49dc3e8d34c19cd3c6c3d5517720d4f3ff"
  license "MIT"
  head "https://github.com/iawia002/annie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebd52671b516b88417c653b1ecd711b69293279cca6fcbbf6a8bc1b8338b3fda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c771f2ab18245eb22665bfec9936d4d1964ef1676145ae03690d1b8d3336c712"
    sha256 cellar: :any_skip_relocation, monterey:       "739f235a703564ce4627eb4f782cc4ca9d42943d863dac3ae18e821087848608"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d3af266455aa28ddcff1c11e05a90e1a279a97b3bad188352e998c1f25307c5"
    sha256 cellar: :any_skip_relocation, catalina:       "e9d19a6e75fb37cd3cdcf8f93390efc424265faa56b8761333450ae838e51a47"
    sha256 cellar: :any_skip_relocation, mojave:         "9fec9894f808c30cca4a7a09c99fa1980ab634dc0a08de3bae140e9de1ed8f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38bc15fc3fd83383e3a48167997df800417b944ab36645b6acb53da122452eff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
