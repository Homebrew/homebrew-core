class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9f0caca307fbaa929eb3f5eb5e5af2f1399625c4418070e2d0fb71f38d275d9c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4818dc0bc9aa936e5d1687e22f2779ef6878e64ce6ec1cf5efe127b1dea2e003"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e76ff5f33fb3928d734d3cc735b3bf41c97375850ac470783e189b394ef091bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8482a1f2699a92e54eabd3310e0c875a78dd7454118eb3984a5cbd9bc0d79096"
    sha256 cellar: :any_skip_relocation, sonoma:         "768619db602730b4223ea86503d14d4e870bfefb681ce0536889c17b03bc63ca"
    sha256 cellar: :any_skip_relocation, ventura:        "bc844dc8a05794c78d97e1d630ab79bc6113afabd02d766bb67e849170fb4af6"
    sha256 cellar: :any_skip_relocation, monterey:       "5050e570cfdbe9bf977352d5c605219e7aee5d846421e3d2e49228a541768727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d41816420b54a4a0f273d64b0232552ed48b3b4143cdfc374bc0fe39e46d64f"
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
