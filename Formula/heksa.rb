class Heksa < Formula
  desc "CLI hex dumper with colors"
  homepage "https://github.com/raspi/heksa"
  url "https://github.com/raspi/heksa.git",
      tag:      "v1.14.0",
      revision: "045ea335825556c856b2f4dee606ae91c61afe7d"
  license "Apache-2.0"
  head "https://github.com/raspi/heksa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4cab211255c75ce7044df346f1b85d3a548c2a760be570a10fcc970a3aec5fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de0c36cdc7215c90ea71792580f298717eeffc2b8d6e7a556cd55e4a9c6fd43e"
    sha256 cellar: :any_skip_relocation, monterey:       "2c40667b5945ee8ce31d17eef4edb72b05d2238bf6a19210885d29471218eb1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f58fd184f70cb5601d2da5737aff2add348d98eeb7724460dbdbebef04bd9ea6"
    sha256 cellar: :any_skip_relocation, catalina:       "98f162aca970fdb91350424f8f4fcf94348b07d598a32355c6e2dfda57b31150"
    sha256 cellar: :any_skip_relocation, mojave:         "deb7aa04db9d74d1300c7b5bfc85243cc853eb7bf81ca0657b3c7bfa6bf499a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c2fa3a47b5d6a492a5bd6b3c881b19714c459adaf3103d1313e9cf9213386a"
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
    begin
      output = r.read.gsub(/\e\[([;\d]+)?m/, "")
      assert_match(/^.PNG/, output)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    Process.wait(pid)
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
