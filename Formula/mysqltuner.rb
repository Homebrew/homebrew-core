class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/1.8.2.tar.gz"
  sha256 "f99551b6b52fab2a416ebe117ae1c45a10bdbd26906b899a4dd4025b1b0feb34"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d651ecf85bc9b4fb50e08ce81f26f5e431702f7e9468541b7216d8b7815e768"
    sha256 cellar: :any_skip_relocation, big_sur:       "52f507064b9ddc66874d5283f11fd083223e1f9ed62dd0bf0ca59a1fb04be4de"
    sha256 cellar: :any_skip_relocation, catalina:      "52f507064b9ddc66874d5283f11fd083223e1f9ed62dd0bf0ca59a1fb04be4de"
    sha256 cellar: :any_skip_relocation, mojave:        "52f507064b9ddc66874d5283f11fd083223e1f9ed62dd0bf0ca59a1fb04be4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d651ecf85bc9b4fb50e08ce81f26f5e431702f7e9468541b7216d8b7815e768"
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
