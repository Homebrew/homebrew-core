class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4fa063299d9fe78c68acbba06947eccf0212315359634e028aeaaff6c8f3a4de"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae05591207cd9d453cec724cd7425357a8570125c363b2819d1ce68613a355b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8294ba369b3519b321abf7c6215fc524b3aa1c3a476ffbbf175522ec5067a534"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f08c79ce5658d1fae06d5737f6339f1e40251d25aa889a653e28970176e196"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9c8fd17bce95b5a08f81e5a56f12d7f8a8de78c163c7db58958c5ac431a0b92"
    sha256 cellar: :any_skip_relocation, ventura:        "f54d29744efb3078a635baf926d166dcdc74be16a194ed1627b9e649642f254e"
    sha256 cellar: :any_skip_relocation, monterey:       "fe7099c41e1be7182188431de4bc439371c8cd6920e89bdb9edd513dcc2ccf35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a7a6f3b75bbed96a733055c333d393b82eee259485f7b3f7d015a49a01bcd33"
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
