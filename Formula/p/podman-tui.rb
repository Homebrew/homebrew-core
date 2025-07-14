class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a94eff698c68bd9b1ed2cbacfbed4c595e514d56c260e0134de951b26fe72f61"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2435900b5565d86c8ea36c078078ad348dc3b54e609b773511cc37b96a1535de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b3dfc370a68d5f1a96499a1b705ecb372a66d59f7714be3c7fbfcc22ddb859b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08dc0ce66e777d44ce7fe4d53b38a1419a6a3f8432d54bdc65cbee7ad1340e26"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd163a3bd9865112be00f0182ff9e4ca70c4039857936aaa8eb5946ea90f34aa"
    sha256 cellar: :any_skip_relocation, ventura:       "6e73ff0b87b1ecea9a14e78b3f3544d9676e246500a6b5c773b0dfa9582b50da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1adeb03d094f67003321f41a0aae0004bfd3a1e3619a93b11de05151af32f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b611e0c14cec9b8d4ceecb727eea57038170145e4cfacc330db4731c3ca6d95"
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
