class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-4.9.tar.gz"
  sha256 "b3971f4f354476a37b2afb498693649009b201550b0c7c88e866af8132b64945"
  head "https://git.suckless.org/dmenu/", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "6d5bd66279c7595ce553efc719503205af487e300623fce212e1155db370f6b5" => :catalina
    sha256 "44e6f96de8f8dd18389c17b99f65a9632cb134b183512ddbd05a542279005f84" => :mojave
    sha256 "297b8b591ee33d1a4f8100de2de275ca15268a906c77c1b4123d0787deb2cab4" => :high_sierra
    sha256 "2fe7512953f6e5099a4a624d8ebc6a3e83bda0753eafa7bb7f2942db90d21e62" => :sierra
  end

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dmenu -v")
  end
end
