class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3400stable.tar.gz"
  version "3.40.0"
  sha256 "61e591388fff3aa81fbd383360d24f85a270422eacf7660aec83df689342cb35"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfdf6bcc0b104468335d1177d859c0dfe895ec78cb5aa0c6cad920e437021446" => :catalina
    sha256 "dced74f97317e6334f8e5be6b482968d790758fd730176155c67bc800f2c15ee" => :mojave
    sha256 "419e1e654803bd9beabbf2433e8e7d643b6b7afe02f13da89633a455d15862b6" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
