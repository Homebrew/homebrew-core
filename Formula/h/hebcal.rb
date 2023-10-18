class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.8.2.tar.gz"
  sha256 "9d881cac33e98cd55056bd38df863b3bcc4476ffda360871e35080ac57e9dc91"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "369de2a072d8facdd70e0f8ac24249be684574f0ce260741c47cecbaabf6549d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "369de2a072d8facdd70e0f8ac24249be684574f0ce260741c47cecbaabf6549d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "369de2a072d8facdd70e0f8ac24249be684574f0ce260741c47cecbaabf6549d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369de2a072d8facdd70e0f8ac24249be684574f0ce260741c47cecbaabf6549d"
    sha256 cellar: :any_skip_relocation, sonoma:         "be9877536bd7a2d7e75c4e7224e1644266829e76f5f8aab5f3e6a065a57c16cb"
    sha256 cellar: :any_skip_relocation, ventura:        "be9877536bd7a2d7e75c4e7224e1644266829e76f5f8aab5f3e6a065a57c16cb"
    sha256 cellar: :any_skip_relocation, monterey:       "be9877536bd7a2d7e75c4e7224e1644266829e76f5f8aab5f3e6a065a57c16cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "be9877536bd7a2d7e75c4e7224e1644266829e76f5f8aab5f3e6a065a57c16cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f60e0176876edbcf9c21cdd6cbe5f242038f1a3b7db499775fbe9ccc6318a1b3"
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
