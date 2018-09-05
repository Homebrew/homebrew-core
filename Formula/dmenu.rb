class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-4.8.tar.gz"
  sha256 "fe615a5c3607061e2106700862e82ac62a9fa1e6a7ac3d616a9c76106476db61"
  head "https://git.suckless.org/dmenu/", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "15dd026e613b5b7ed40f636be7c0eecb2cc77398da667356befc7884a48b3793" => :mojave
    sha256 "3882f8888be8c8e4ba11e22bca628e6b5a58f409bc4a40cd9ce542ad936f74c7" => :high_sierra
    sha256 "48dc8fccfd0ad4111582ee8795a906e2c22160f985c993c73f625cea4e814937" => :sierra
    sha256 "d013c1af685745f8d4c00f1366d15ada35e6f3946682798cad0963e6bd3e07cd" => :el_capitan
  end

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dmenu -v")
  end
end
