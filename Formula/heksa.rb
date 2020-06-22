class Heksa < Formula
  desc "CLI hex dumper with colors"
  homepage "https://github.com/raspi/heksa"
  url "https://github.com/raspi/heksa.git",
      :tag      => "v1.12.1",
      :revision => "54a68a2910a87b8b9cfcda28b8693e18dd9e2463"
  head "https://github.com/raspi/heksa.git"

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
