class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "863d2511438e1b9e407995a689cb877f69fcea71a93a88b2e1b9924930e84290"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39a2c374d749781e68281a280b400d3abc06e6c7782ba7030beeaee95bf69aef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39a2c374d749781e68281a280b400d3abc06e6c7782ba7030beeaee95bf69aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39a2c374d749781e68281a280b400d3abc06e6c7782ba7030beeaee95bf69aef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39a2c374d749781e68281a280b400d3abc06e6c7782ba7030beeaee95bf69aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbbcafb76c42d1e1da52f5772732eb6ce8d437dc9399eada755591d57c814d3c"
    sha256 cellar: :any_skip_relocation, ventura:       "dbbcafb76c42d1e1da52f5772732eb6ce8d437dc9399eada755591d57c814d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94744774a04b8cae4e175e6dc3e55303f75b29f7217bd39dda6f39c47f73aca0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
