class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3410stable.tar.gz"
  version "3.41.0"
  sha256 "600912072cce09e2633ef9737bf741a4bb7d60a533a6dc2f6a5a425bc6186f4a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e63c6e51b8adfb080c6380cf99f449f29e4aea512dc355d188ee32d9421d0ed" => :catalina
    sha256 "852c533d1c8680912cdf33a1f271f747ec9cd67b1076e57f72cbef3f80edb3ea" => :mojave
    sha256 "d4812f740e9875219bbe7a707804cc9d3e65d7c7f412d54ba7985c9cfae920ff" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
