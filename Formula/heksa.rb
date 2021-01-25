class Heksa < Formula
  desc "CLI hex dumper with colors"
  homepage "https://github.com/raspi/heksa"
  url "https://github.com/raspi/heksa.git",
      tag:      "v1.13.0",
      revision: "4342bec6160ca58e90890e87f276044e7aca3831"
  license "Apache-2.0"
  head "https://github.com/raspi/heksa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e48a732eb3825a7cbd0a2b96d6692592f9c15d365d964cce4bb8f92cba432a50" => :big_sur
    sha256 "c4e1fa619ea432a08a79cfcce85ec55ee1fc159ed7b1d46a798d2a0edae5e822" => :arm64_big_sur
    sha256 "771946a21e72b9d5eea465ca9fd213615b0eba272820691905522bea993ce6a3" => :catalina
    sha256 "7592f466b87e68f8e4f4762bc0ed6cf14ac92a127ef6fdd0cfbe3d4fdb550b05" => :mojave
    sha256 "14394cbe0fe767fd205e96ec62b27e7223ad48231f61d30271b5516bc99e652a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/heksa"
  end

  test do
    require "pty"

    r, _w, pid = PTY.spawn("#{bin}/heksa -l 16 -f asc -o no #{test_fixtures("test.png")}")

    # remove ANSI colors
    output = r.read.gsub /\e\[([;\d]+)?m/, ""
    assert_match /^.PNG/, output

    Process.wait(pid)
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
