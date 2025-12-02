class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https://dmitryfrank.com/projects/nerdlog/article"
  url "https://github.com/dimonomid/nerdlog/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "95fb629044c5a74c2c541d4c39a9622674f15e59b98e6d1b025a47c218f69189"
  license "BSD-2-Clause"
  head "https://github.com/dimonomid/nerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c5c89f5703c5254d79bf17a35b93a5fee15af1df0b0ca8983c30e5994fce9f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6fb84d243d9107eb44579b8efb03c69d1378ce7d51000e1485f7204d115db7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9336a81b6b484ea7d3381cb51c854a2ab11f23e2d5a06ad1b7639e0d956ec503"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ce359089fa9e49ad6b31ce3e6b85e7c39f4ecdc0a71acc8f9070246566bfa24"
    sha256 cellar: :any_skip_relocation, sonoma:        "942073a7a936ef2b14570bb472c2e044a21ccd43d9cc8076bb4524e2f026dd60"
    sha256 cellar: :any_skip_relocation, ventura:       "fe0e4d94a6541428b5932e6dd1fd26165f4ea70dfc4767d3051bb2191c302a02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e9c31155687ffe5ca26602124ab8326b6241afe7c78ec2d7595ade960d85dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9007cfebff78d395297b19ebf89943c4ca617db012ba47246a8f9389030e5faf"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/dimonomid/nerdlog/version.version=#{version}
      -X github.com/dimonomid/nerdlog/version.commit=#{tap.user}
      -X github.com/dimonomid/nerdlog/version.date=#{time.iso8601}
      -X github.com/dimonomid/nerdlog/version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdlog"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"nerdlog") do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        output = r.read
        assert_match "Edit query params", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match version.to_s, shell_output("#{bin}/nerdlog --version")
  end
end
