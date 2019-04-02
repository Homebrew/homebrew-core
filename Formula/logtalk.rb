class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3250stable.tar.gz"
  version "3.25.0"
  sha256 "8a185f4a6dbc3b0b322595d82f194bbd397ca70dc772af5ac62694e741ee1270"

  bottle do
    cellar :any_skip_relocation
    sha256 "8db8435080b7493e418f42173098d296486c67b6de183995a8680cd5859fcca5" => :mojave
    sha256 "a2414773437e60d53c9f657d5cc8cfabe514e73302960355b9afe02178a58dd1" => :high_sierra
    sha256 "5dbf80032c447a35c8135963c86571cb8f69498a391befb2e9ef82c535a83a97" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
