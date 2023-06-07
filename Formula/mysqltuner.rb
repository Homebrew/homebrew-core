class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "f5a8ef9486977dd7e73ef5d53a1a0bf7f3cc7bf9ba9f9f4368454352cd0f881a"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f48fec89712f94d011cba520736fafad466bc9f33eddb580b1b2dbe8dfc4e83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f48fec89712f94d011cba520736fafad466bc9f33eddb580b1b2dbe8dfc4e83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f48fec89712f94d011cba520736fafad466bc9f33eddb580b1b2dbe8dfc4e83"
    sha256 cellar: :any_skip_relocation, ventura:        "dde5020c41fd2f0a91dc626bff3a72649f78498d5bdcd7098dc60ef7cb323381"
    sha256 cellar: :any_skip_relocation, monterey:       "dde5020c41fd2f0a91dc626bff3a72649f78498d5bdcd7098dc60ef7cb323381"
    sha256 cellar: :any_skip_relocation, big_sur:        "dde5020c41fd2f0a91dc626bff3a72649f78498d5bdcd7098dc60ef7cb323381"
    sha256 cellar: :any_skip_relocation, catalina:       "dde5020c41fd2f0a91dc626bff3a72649f78498d5bdcd7098dc60ef7cb323381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f48fec89712f94d011cba520736fafad466bc9f33eddb580b1b2dbe8dfc4e83"
  end

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system "#{bin}/mysqltuner", "--help"
  end
end
