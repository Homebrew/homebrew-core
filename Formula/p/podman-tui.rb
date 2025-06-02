class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "4d7f8293a5bcc900839a51a6d0852df260ac08982a601480f0090a2182636fc2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79efea58f02c47ee9630202a7c0d3473f5954dd09809e2887e6edf8da169dfd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e2053f5b4107d11f5e23d6422e7b3113c305cba4b754720ba122df9be87fbae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34390f4f507289046e8f726e7eacd012870cef01fb6d804a561bfc66769ae350"
    sha256 cellar: :any_skip_relocation, sonoma:        "9686103029361936dbf43c27aa04cdac41bc880dd958660dcf8964f5d734f687"
    sha256 cellar: :any_skip_relocation, ventura:       "09448c1ad7f8731a0b5a3995a891d76e2832aa9301c11540798c52a6aa8ca206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25a0f4cb399dc69b5bd5111a93ebbe1f81490eea55a5c69ddc56b85342921b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41cbcd43594f15e7709dab351e412b5987fc4c6ba8ec44b4b9eaed92609de8b9"
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
