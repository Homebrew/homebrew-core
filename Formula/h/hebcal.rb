class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v.5.8.0.tar.gz"
  sha256 "dd710bead0162ee853078f4c5abfa696fb4076d0c1a41659612d77c554d30349"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f314943ba063fc38c148435930ae54d713c521bffba09d3b783f448ffdf3a956"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f314943ba063fc38c148435930ae54d713c521bffba09d3b783f448ffdf3a956"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f314943ba063fc38c148435930ae54d713c521bffba09d3b783f448ffdf3a956"
    sha256 cellar: :any_skip_relocation, ventura:        "0ad9e2e90b0982fa477f31b268755d97f0481fb4df06fd83505f81be435eec63"
    sha256 cellar: :any_skip_relocation, monterey:       "0ad9e2e90b0982fa477f31b268755d97f0481fb4df06fd83505f81be435eec63"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ad9e2e90b0982fa477f31b268755d97f0481fb4df06fd83505f81be435eec63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8781cd6b1684f34af41fb7b1580ce921b589970c747371bfe91a4bff47f7e2b"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
