class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3360stable.tar.gz"
  version "3.36.0"
  sha256 "10c34e1a3f92758736e29578c0f412d65d80745f0a3bb13bd2013e7a3f5328a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd156d5815427513d6d2a699a4a2050edf33310688c28fa70c16cfa7beea53b1" => :catalina
    sha256 "02a2b34caa80c8dcca7575ca06b99c232ade45d9fc4f38a107487f8e13375869" => :mojave
    sha256 "08c332c858541a0d5584b184a3a6db3dcc169e8cca7d014e0a07620a1f42db3c" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
