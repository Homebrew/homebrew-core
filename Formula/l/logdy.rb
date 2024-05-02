class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "e37f925e804b8429b1302150aeb99ceecf3ea2e4781d9aff40f75fd94d9de7db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f061c43b5e20f8d7b70b01d7ff2bf26fcdfe5192878cb320f7b8482b43520e82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d31c26ce57d90cd1454de1c5bdce9c119ccca9f04b6f2e7af46a3cff765d73c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3931ced818de4aaa31c12a6aff006d3e761bd3190b5c2e41b4771a1830d1d2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0441a3d5ea357fedfc7df8529e169de6270eca64bd265c75a9b31190278c54e3"
    sha256 cellar: :any_skip_relocation, ventura:        "111e08f8a90868f07b0af542914a190ce8afe3bcc7e4563af5120390c8cf5a79"
    sha256 cellar: :any_skip_relocation, monterey:       "e660216f24dbc34cc488f8fd50925f921e0ec2d5b554cc83d149be276fbec54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e7164411eee4cda333c8801e2b5398890cf1ccdfe80546f438d9e7235ff676"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _, pid = PTY.spawn("#{bin}/logdy --port=#{free_port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
