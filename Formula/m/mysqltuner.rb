class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/refs/tags/v2.2.12.tar.gz"
  sha256 "51d7f569ec2fde5ffbe38731e79c8b113899bbf5ea200fc407c622a359b2cca4"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98d7ffd6b70d13f6dc196a3123a6714ce3df78e6f0ee7d69f330c5378b76b99a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98d7ffd6b70d13f6dc196a3123a6714ce3df78e6f0ee7d69f330c5378b76b99a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d7ffd6b70d13f6dc196a3123a6714ce3df78e6f0ee7d69f330c5378b76b99a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98d7ffd6b70d13f6dc196a3123a6714ce3df78e6f0ee7d69f330c5378b76b99a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e9380ae45cc0494ebd7d96a4a8f140406c78f014756258a5e5e5839a130adbe"
    sha256 cellar: :any_skip_relocation, ventura:        "7e9380ae45cc0494ebd7d96a4a8f140406c78f014756258a5e5e5839a130adbe"
    sha256 cellar: :any_skip_relocation, monterey:       "7e9380ae45cc0494ebd7d96a4a8f140406c78f014756258a5e5e5839a130adbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e9380ae45cc0494ebd7d96a4a8f140406c78f014756258a5e5e5839a130adbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d7ffd6b70d13f6dc196a3123a6714ce3df78e6f0ee7d69f330c5378b76b99a"
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
