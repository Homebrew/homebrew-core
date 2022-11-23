class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.4.4.tar.gz"
  sha256 "c7ba623990bd092a2cdc2c15390172d8f111c30a80f7d1c126fba28db74915d5"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f70e12e06e3bc460418ba47744b5b01b04ff3870b1b2ae84108911e40375eac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f70e12e06e3bc460418ba47744b5b01b04ff3870b1b2ae84108911e40375eac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f70e12e06e3bc460418ba47744b5b01b04ff3870b1b2ae84108911e40375eac"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef8114b08b581cc9473336f90c52674267ad123c8c6dcfae325f6c81bb9be92"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ef8114b08b581cc9473336f90c52674267ad123c8c6dcfae325f6c81bb9be92"
    sha256 cellar: :any_skip_relocation, catalina:       "7ef8114b08b581cc9473336f90c52674267ad123c8c6dcfae325f6c81bb9be92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ddacd7d0b43fee32b4f161686f46a45c334701888f255106ad3339027b0085c"
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
