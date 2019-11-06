class Ksh < Formula
  desc "KornShell, ksh93"
  homepage "http://www.kornshell.com"
  url "https://github.com/att/ast/releases/download/2020.0.0/ksh-2020.0.0.tar.gz"
  sha256 "8701c27211b0043ddd485e35f2ba7f4075fc8fc2818d0545e38b1dda4288b6f7"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "f293f9efa89e7b6cb6318ac6406e61de92b05b85f9c1fd17affccb38e941b64c" => :catalina
    sha256 "d6a44587ba5c9ef60ccd4df40bb4e5b4be2a6fbf6c3269d1732ba7376b341c8c" => :mojave
    sha256 "5ca742b83c55b817a0fa09f737d73530c0f73d89618c60a19ec2ea5251ef8cd4" => :high_sierra
    sha256 "37a9f6c57702896fabe762fe90ebe454f04f3523aea311a28d34dc884d53736e" => :sierra
    sha256 "5148e18444c7f1a4e7b71f72982362491aa5581101296acaa6d9c2a782d620b1" => :el_capitan
    sha256 "13f85c7df7f44b68f1e5560c05b61eff8145230d94986537bdee5702c1e72e68" => :yosemite
    sha256 "7c665466fb323fc0cb6ffb87ec9fe1630d75afcd3b12864e2424677473db4924" => :mavericks
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/ksh -e 'echo Hello World!'").chomp
  end
end
