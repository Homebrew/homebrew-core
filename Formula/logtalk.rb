class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3060stable.tar.gz"
  version "3.06.0"
  sha256 "4adb097bf27fc8e90e1df534bf5ef290a4cc96fcf8f60bc0a7dc5dcb0098fb44"

  bottle do
    cellar :any_skip_relocation
    sha256 "21d73ea4b61d0c48d1e9a439a05ac777bb7096c54ded716a8c7ab5848c2c3002" => :el_capitan
    sha256 "025b345f196b0df9a64a72166b7d0ab2402c82bdf0ebbdfa39f0e9e046ec2fe7" => :yosemite
    sha256 "2886b004e64e58884ffb10639c5ffdae3c248167e21963426bcdfae1649f84bc" => :mavericks
  end

  option "with-swi-prolog", "Build using SWI Prolog as backend"
  option "with-gnu-prolog", "Build using GNU Prolog as backend (Default)"

  deprecated_option "swi-prolog" => "with-swi-prolog"
  deprecated_option "gnu-prolog" => "with-gnu-prolog"

  if build.with? "swi-prolog"
    depends_on "swi-prolog"
  else
    depends_on "gnu-prolog"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
