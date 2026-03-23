class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.0.6.tar.gz"
  sha256 "5e52173ce725fa90f88d206ee614ad13c626dcc6329a5696c47d283e8f8d4483"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3463cd09bd53275d647ea70924519107915bdeac48445719a11e300933f337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3463cd09bd53275d647ea70924519107915bdeac48445719a11e300933f337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3463cd09bd53275d647ea70924519107915bdeac48445719a11e300933f337"
    sha256 cellar: :any_skip_relocation, sonoma:        "495b9a3760f7aa3ca285e74ff6c4f36d5f35021b6ed2faa8e50b0b7e6c520711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07296dc34e1391199537f33a18c9d6d2dc99bc1248d9d6d1e5821fa5f7ef4fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb611206e482118ea510bed2e484a6789ff17fd5faeb617e2a12078c8aee30e4"
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
