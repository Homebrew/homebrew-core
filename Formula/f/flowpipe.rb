class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "296284cbce2b4a2b35a8df008707af32ea1dbab9b0978fed436221f469a92ec2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc82a8eed0ea2c282da8ac4a5d3ec8de73dc97b28da537c5e1e9da984a9f43a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "133682e88d1f0cc86a27dd96bf5dde1f782ccc7ae626df85efcf03fc2af64be2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cec614a55c4e5329a0a384f1d6f232915020e8bc64fdd24b8140b7a06337e31"
    sha256 cellar: :any_skip_relocation, sonoma:         "7978fbfbce0634e6602e07651fc7ca2484c9749ff9d341461a06dc039dcc595c"
    sha256 cellar: :any_skip_relocation, ventura:        "5fae9b239c5433b570d49769f93b71147ca1499098d5796b575e37dc8ca4da87"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ee031195ffb898294819f63e551337d7601f70a875d03951bcab9881b5963e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ef86dc52d5373b1dbb0f49426cc000dc4c6f506dffc81eb25c41845928c622"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "ui/form" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowpipe -v")

    output = shell_output(bin/"flowpipe mod list 2>&1")
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end
