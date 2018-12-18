class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3220stable.tar.gz"
  version "3.22.0"
  sha256 "58cb741ccd7adc6ca0269eedea205c8f47473a3f0de325e114988374cd342964"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d7d9e12ea27e48c93d53c3a200d1f2c51c991e841c9442b962876b8acccc843" => :mojave
    sha256 "4c96c3fb6e599d3625385150dabe2fa8fd73e5127dc51579f3f54eeae475104c" => :high_sierra
    sha256 "3d5a464aa1d1d5a2d4f9e5cc0ca97350853751513b8687e6108f4a13fa9e4aa3" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
