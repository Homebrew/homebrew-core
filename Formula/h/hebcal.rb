class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "cfb17be1a0c112a03b06c339b70d5a0a519333da9a7f699728e77c6a88dc866b"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eecb7970671787b9fd7b09e99e33fa687478318306daeba4b6de7e397967ebb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eecb7970671787b9fd7b09e99e33fa687478318306daeba4b6de7e397967ebb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eecb7970671787b9fd7b09e99e33fa687478318306daeba4b6de7e397967ebb6"
    sha256 cellar: :any_skip_relocation, ventura:        "8fed100c7203f750f756ca83b02840a32eff7ff7656603a92f62b2e6cbf3ce30"
    sha256 cellar: :any_skip_relocation, monterey:       "8fed100c7203f750f756ca83b02840a32eff7ff7656603a92f62b2e6cbf3ce30"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fed100c7203f750f756ca83b02840a32eff7ff7656603a92f62b2e6cbf3ce30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "120da2732c8aab36db530ce1317ae79c39be2937f1836a1a60189e53aa1a32cb"
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
