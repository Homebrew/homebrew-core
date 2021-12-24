class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.30.1.tar.gz"
  sha256 "04c0508fc64958b6be8f7cb36d1f27009a2adbd46ad37aacad390d7ebc4c8e7e"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57fdd1027fddb1d45e729ad4fa38386b5d6eb223511b2b7227a2a7b2e30c139c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edbbaa537bad361738df7dbf52aa77287cbba083fbdf1b405172cf1e19676d28"
    sha256 cellar: :any_skip_relocation, monterey:       "a1021531f359b0515257ba20f88f5bde1dab5b8c124c584d6e59bd4609e1f4f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "90419694384fd2395571a539ac43b3c64eb5dbb19367bf5bc274b47dfef9fc28"
    sha256 cellar: :any_skip_relocation, catalina:       "4bc28d7cbb6a97b166b651494e45eb53d3031799cccb044298b108a4502aceda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8c43a2e79cef6e1e35e044984df29efebfbebeb8d5b33b81423b6ae4d6a07a"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
