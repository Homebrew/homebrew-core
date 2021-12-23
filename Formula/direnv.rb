class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.30.0.tar.gz"
  sha256 "3d39d38a5341df801053198828a21a128453089baab295b71ebd520d390764ef"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e565d2a681d1b0c1421b0e22430af07897a03d0685b1dd02b1f6f807397d8ea5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7385c6be31697093342964ea909ec42a9e6bdbfa4735344533f1232323f736e"
    sha256 cellar: :any_skip_relocation, monterey:       "0cf972f44e80cbec09e323f6467d3ae62b2633c04df3c3d99395c56effe0ab97"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fbb90c21a4fa0c7a6e20073fe0497305477a6c9a5ba4dfbedd18119221bd4d3"
    sha256 cellar: :any_skip_relocation, catalina:       "682ab5b3d43dd5dc11b911e7c4a25725616b738f3be6e7326c649758bd246c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20504644555e86b0dadaec87c2712c6a43fc7f5c24cc1da874b9a890b81f9247"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
