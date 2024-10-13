class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "97243e025bf8a0ad4b7e87197cc4e608da0af8bb447b1ffd0e01bcb58273b619"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83c3b460f93910e1b589b3b6e8ae9d2fe363f510dc6aea33e2f471c9648bc9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d04b6a5925549a29c5a158224a9d2177604e2c5d4510c5e19c58d5291322f3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f95d4e01e226c0de1500085af5035c3264aa121505107c7decab8231aec96d97"
    sha256 cellar: :any_skip_relocation, sonoma:        "823f0a659dddd8bff4fffd1daa21bd60aa1e04b8b72c334838fdcf06192d66d7"
    sha256 cellar: :any_skip_relocation, ventura:       "7db875e653898963386d254f8985a8e5d07f8e5b5d1d958f830e8d138c86f6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f22eb25b29db89d0554217e6dc60752a5f9a1b49e077388e3ac013afb618a365"
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
