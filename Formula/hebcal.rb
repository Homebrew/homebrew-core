class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.4.1.tar.gz"
  sha256 "c5cf3b83d60128a7e6a4de570ed3e755a9beeb6b2e31d646dc001871d113bac0"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d347e2cef64fed8726574606ff57d8ea85413d92102e92e767acf36a840b649"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9dba411816dc45ac780d642f6988f0a548e958db865a79392f740cc021473f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9dba411816dc45ac780d642f6988f0a548e958db865a79392f740cc021473f8"
    sha256 cellar: :any_skip_relocation, monterey:       "c2e706d062fb07301b1355112099772736c5710ef20e6c2fa439565cf6ddd22b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2e706d062fb07301b1355112099772736c5710ef20e6c2fa439565cf6ddd22b"
    sha256 cellar: :any_skip_relocation, catalina:       "c2e706d062fb07301b1355112099772736c5710ef20e6c2fa439565cf6ddd22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "980b7c1d82d4ac59521733e298c35a966b37fd94a689f6945504e642bd34a6cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
