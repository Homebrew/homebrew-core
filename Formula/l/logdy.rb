class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "bd5db124e736e42d3671697787a26b354e0be6e787a95e69c054ad873058fcec"
  license "Apache-2.0"
  head "https://github.com/logdyhq/logdy-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7379d846c24e613e23388d5e31a603494119bf223da64f165cfb4864ad50d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3eeee30fcc05e4c7265ee505fd23095dff74d6154866ddeeaeaa76ef5d240b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3eeee30fcc05e4c7265ee505fd23095dff74d6154866ddeeaeaa76ef5d240b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d3eeee30fcc05e4c7265ee505fd23095dff74d6154866ddeeaeaa76ef5d240b"
    sha256 cellar: :any_skip_relocation, sonoma:        "282b0cb5c348d5d7bd00ba2c20df88ec44f27ae6d18bf38a4f8b3bbfda8a1859"
    sha256 cellar: :any_skip_relocation, ventura:       "282b0cb5c348d5d7bd00ba2c20df88ec44f27ae6d18bf38a4f8b3bbfda8a1859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332340c409d174dba7ccd3c45ba80c50f3d045e31d9027568d4809bf246ec457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6799e27353bd503dd977227b839131b17ff91a0006562464465eaa6d165a0bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"logdy", "completion")
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}/logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
