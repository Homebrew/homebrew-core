class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2616749995cb787e9dce2a773d531fe5e0bf833b18ab6242c65c873655300792"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7eab176fea58bd434d6d7a8df4ed63527517549168c901dae6a9a9a2edc9b1f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cf25203ed768a0c4c6f400cb3c37f99904814315cfcd57b47b34209a2ca4246"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b91987a044451a50d39da6e48205e52b72edea6a7edf06070e08253045a9cac"
    sha256 cellar: :any_skip_relocation, sonoma:         "3beef012e03fd2096542f8d6591a4ac464fed0ccbf28e13275e7cb6215aa5ccd"
    sha256 cellar: :any_skip_relocation, ventura:        "5111291f349a1fa607a0b658ad63b0374c3e2509a3b89152e537887b1b1a01db"
    sha256 cellar: :any_skip_relocation, monterey:       "49413d24066e44eafaa3f65ed019a7a42ed2f33b220e10b1e189918158b768b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f5b9d75ccd2e1e3e445bc6cef987eb084bf838c8ad0fea1b34d7ade019088d4"
  end

  depends_on "go" => :build

  def install
    if OS.mac?
      system "make", "binary-darwin"
      bin.install "bin/darwin/podman-tui" => "podman-tui"
    else
      system "make", "binary"
      bin.install "bin/podman-tui" => "podman-tui"
    end
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"podman-tui") do |r, w, _pid|
      sleep 1
      w.write "\cC"
      begin
        output = r.read
        assert_match "Connection:", output
        assert_match "SYSTEM CONNECTIONS[1]", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match "podman-tui v#{version}", shell_output("#{bin}/podman-tui version")
  end
end
