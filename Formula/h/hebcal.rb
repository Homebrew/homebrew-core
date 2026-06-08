class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.12.3.tar.gz"
  sha256 "ea5ea21f243400c2ebf0231f31b86bd68b1f3b2a68d4c8ed300d83db28c35ab0"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "748d9e940aea0d9b758114b33a068ec2cabbedd8dc38094bf769970224eeb07a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "748d9e940aea0d9b758114b33a068ec2cabbedd8dc38094bf769970224eeb07a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "748d9e940aea0d9b758114b33a068ec2cabbedd8dc38094bf769970224eeb07a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aea102de276416926f2d9e940aab559149a8fa483e2a019ae580da71ba3521c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba0c2b00876c505eb7f8fa4c46d9c8416a98f23af844025df39d138f1741d26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8806138d04cb1d8f63d8daf8efa9790d4be92148ee02f28a95aaba7910803ea"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
