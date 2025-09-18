class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "56ac081ec9b920443646bd3735277837cb10db783c52f1e8dc7c140dcd6d0526"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57f4498f0a1354db21be95d5f5ef1c7aef0094b90a3b984b98c4bdf47417dda1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88632bfd3ef1ffcc834051ac740dd87690a2d04d75ace5431a826b47ba439f3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bf84df62d3ec74e7fae87880caae2a231b30208043e63bb65d14b5665615af6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1315b1f6b4bede53c454dff78c81e44e31c2001bd99e3b737b310abf9e9bd279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bbb9f41666144412693cdede71f1432f1d870a5cbafb31f92bb6f5b66a8d922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539cdde7941158f15283dfd9b6339955c58f04224d71edb7d555067471021b4f"
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
      sleep 4
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
