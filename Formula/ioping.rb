class Ioping < Formula
  desc "Tool to monitor I/O latency in real time"
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/archive/v1.0.tar.gz"
  sha256 "db999abb0f9de00bce800267965cdd9b826ebce6052e905b12d9f40076157088"
  head "https://github.com/koct9i/ioping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecb8704feb7a9ac48e1cec7a9f8acaf60bd251e34fe8fe69ebd46e874bea1e47" => :mojave
    sha256 "f08f3749c114d01348117df60ec07da9341f8834640cf5f1fbcdaaf944218065" => :high_sierra
    sha256 "aaee4af9debb8152ff634033e61e6abd8e053295620dfae725827cdece5a670b" => :sierra
    sha256 "95316d10ae971b67aa383d785e3c26b07172446fe353d3952dc872c693e57ee5" => :el_capitan
    sha256 "ed5b9ea5dcf6ff4af74d71af575f2c1bf12ae94b7b2a40c32105d027e1ff9333" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-c", "1", testpath
  end
end
