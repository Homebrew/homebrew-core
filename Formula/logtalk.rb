class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3360stable.tar.gz"
  version "3.36.0"
  sha256 "10c34e1a3f92758736e29578c0f412d65d80745f0a3bb13bd2013e7a3f5328a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fdd3e84ed22f4d65e748c2bcfa92bf60453afb0e397d20cc4abf03a3d224c7c" => :catalina
    sha256 "2fbe659dcab804490ad25766e20f64e5462ec91f087e81247c02514d85e4675c" => :mojave
    sha256 "a40510077d0dbdc14f2faa0d81c2f5853cd1222b9dec9ff5b90d9f0d94d32ba2" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
