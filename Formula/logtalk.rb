class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3310stable.tar.gz"
  version "3.31.0"
  sha256 "59c164305959de4d11f96cb0571bf46bca592ff77c4af8591b26b9b57f394bdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9ad7e87ed012430c2e32425ee501f319487fcde39daa2fdf5ff1730a616841a" => :mojave
    sha256 "e4ee20e909fd09b0cb5b85db0c35471fe669f6e8273a50411314807ab88afdd4" => :high_sierra
    sha256 "2e4427725333531dce3961ff743d8851a3be3e3ea1d196f8d417a2fba85f549c" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
