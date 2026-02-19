class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/0.12.3.tar.gz"
  sha256 "e9907dc43091b85683a4c3b52b0e4bf94ca821618ab21dda212e069ce455b19e"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a42af0ee4975bca958446f5f5419e0fb8beec1002f3328f595463ac60a43fdd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a42af0ee4975bca958446f5f5419e0fb8beec1002f3328f595463ac60a43fdd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a42af0ee4975bca958446f5f5419e0fb8beec1002f3328f595463ac60a43fdd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb51fa8fda981688358a958e0ccf339a5ee0d5f1eac710690d6cbc7d7da982b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607a178c9d132d30fd32312d2c3496d610c82a31edd6967e0dbfc69d9098d88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d3646d3aaa93dc34d9864723976e598eb03415dfcf1b881f7c64e4eab58b61"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end
