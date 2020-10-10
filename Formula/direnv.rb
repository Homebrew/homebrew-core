class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.23.0.tar.gz"
  sha256 "d28bc959680a309d0d54f754edfe622cdde14a4b806fdd32d285d47a322098b9"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44e70a14fb3eff7708df0c7aa46701b4476568cf2b7fd06f68ced2dd0a4c52f7" => :catalina
    sha256 "3214ef11c015566e5d4891242659d89705dc45ee84c76493280d88264cc2cff8" => :mojave
    sha256 "7463876a5196f01d219cdadd5d57ee4f035e0d4c37dbf9d18bc8d99738c05160" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
