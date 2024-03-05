class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8b0b64e377e2660770a466b17b9c81b7e51af5ac748460d79911b842ebdc9781"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33cc92f3948c8646ca76f044ebe6d5b9aa421e8b96f5f55c1b84e8b902f1a212"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32caf936d6965a807612fc8e22a13a6b7f05f23fdf78a364159d46f5eb9cd900"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d26ac4cf9bc5e4016b86a1d6f17b5fb32c146081969babe474a19a69c83573d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "41eb003b11546b51d80a12bbba380800062dad7daacc7e0d55f135f11b9b772b"
    sha256 cellar: :any_skip_relocation, ventura:        "6053f596c73333fbeaa14ba53320152a3d2dad724af3e7c8ff9fa19aa9641802"
    sha256 cellar: :any_skip_relocation, monterey:       "521648cefef620ce5a558e675c5d7841f8bd47039038cfb0533540b0751882bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef76625ac679eeaa483e3b77570942c05fa3042ac76a095fdff9b7ab31b5ea99"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
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
