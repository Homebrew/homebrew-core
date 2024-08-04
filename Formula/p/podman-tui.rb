class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "feb8249ea05d7f53e2bc8036cff439d04a09b9628f70355e280cfc5d7e8919f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6f9e686a8e7135f5387a64ff49a7aec5c0b7f3f417538cd1a3e852be2df07e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ad3ed882d28ee3df7ee73f7a28e1012b8010a3b3657ca7b64d6092f58ac53ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4526653a199454d9bad95e3f431cd6e31de21c2006379bc402062c2f2aeb233"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2e9e1dc06c21a05df6355c5b9e4fc1bedaa99692d18c1995f2b0e251322fcb4"
    sha256 cellar: :any_skip_relocation, ventura:        "a6d829d72a36e2f15d7eb8b4230d8af06e41a6b8c4fc97c79bb37b68a4ce4c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "7e7646d51e1c5837e1b341060e487dd190b918eea998351dfb4a2ad73678a0a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2746956a68fc2544d6598b9169ecda53cab11ef896bdd0cc14c2dfb7e3a9ec5e"
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
