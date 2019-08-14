class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3280stable.tar.gz"
  version "3.28.0"
  sha256 "308e6d6c4c4f56d9507d3c654b7fa8c0db0e6168ef04a2583efec33a79a5d946"

  bottle do
    cellar :any_skip_relocation
    sha256 "2faf1ca1f9fe57601031c0608196961c85e2fddbbe7158749cf8192afea09a92" => :mojave
    sha256 "61d14b01abacb9f7dec610f7c08721b63cda9738a8b7a7cfe6f6c27908618b4c" => :high_sierra
    sha256 "41dad06e989e133d836bbe0fe2815a72a65cb1b07df76fde221bc6ef8440f9ad" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
