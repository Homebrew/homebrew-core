class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "9ba57ecc616c1791907c1e7befe593fee23315bcff0121adc13dbd62b2553a3c"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4318628650fdf57da48a1c5ed8c9f6f15f7fe6ae5d59dbacfe4121ccc5e25d4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74f01fb8c0235b1e38e4fff0977de554aae2f6743be6d6e91c4788e0fc972373"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74f01fb8c0235b1e38e4fff0977de554aae2f6743be6d6e91c4788e0fc972373"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74f01fb8c0235b1e38e4fff0977de554aae2f6743be6d6e91c4788e0fc972373"
    sha256 cellar: :any_skip_relocation, sonoma:         "20ff3ee36a24a74ef56302b7d61732af0411ae442f20c9d89ff4db4acb38bc29"
    sha256 cellar: :any_skip_relocation, ventura:        "20ff3ee36a24a74ef56302b7d61732af0411ae442f20c9d89ff4db4acb38bc29"
    sha256 cellar: :any_skip_relocation, monterey:       "20ff3ee36a24a74ef56302b7d61732af0411ae442f20c9d89ff4db4acb38bc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74f01fb8c0235b1e38e4fff0977de554aae2f6743be6d6e91c4788e0fc972373"
  end

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system bin/"mysqltuner", "--help"
  end
end
