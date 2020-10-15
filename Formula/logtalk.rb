class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3410stable.tar.gz"
  version "3.41.0"
  sha256 "600912072cce09e2633ef9737bf741a4bb7d60a533a6dc2f6a5a425bc6186f4a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7890c6a4ccdd1dd02d00c95c3d19948b2d27daca33bb7af655225f97b835af63" => :catalina
    sha256 "e1bf996dbbfe993dbc4b601664a4b4922b8751f0fb45fdf0addf8d120328fac0" => :mojave
    sha256 "3a5fa86108e5c6476ed1f2a827563fcb0e9b4fefb64b27d70f1b2d8bc2ce7dab" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
