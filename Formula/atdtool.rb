class Atdtool < Formula
  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://github.com/lpenz/atdtool/archive/upstream/1.3.tar.gz"
  sha256 "eb634fd9e8a57d5d5e4d8d2ca0dd9692610aa952e28fdf24909fd678a8f39155"

  bottle do
    cellar :any_skip_relocation
    sha256 "c83db7e4362cecf9d1c44864b71577977c2b288144c651dcaffcf92779eef3de" => :sierra
    sha256 "3c03f9deaae3f420231b6fa5331e3d213dc0d48c8817a7142403d35d54159283" => :el_capitan
    sha256 "8120a3e4b9e2cbc74c533baa2fee5427cae2ebfbf634a39d75c3e2481159b03b" => :yosemite
    sha256 "efda2ae7e414ac866210899a3f037e565631d07957c7ed44ffefc306d1944901" => :mavericks
  end

  depends_on "txt2tags" => :build

  def install
    # Change the PREFIX to match the homebrew one, since there is no way to
    # pass it as an option for now edit the Makefile
    # https://github.com/lpenz/atdtool/pull/8
    inreplace "Makefile", "PREFIX=/usr/local", "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/atdtool", "#{prefix}/AUTHORS"
  end
end
