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
    sha256 "346f10b8cfc84fe37619e925372c27b7787beecd3d240a3f381fdca629da117e" => :catalina
    sha256 "481e0b181ff88978df7804ff8f657821b7802a9c2fe3937bb949b723e55a4369" => :mojave
    sha256 "cf17ed8f9f50e1c4c1864b8847e456bf6a93a89bb9bcb76416393effbcf4d441" => :high_sierra
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
