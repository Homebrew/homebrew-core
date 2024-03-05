class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8b0b64e377e2660770a466b17b9c81b7e51af5ac748460d79911b842ebdc9781"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "458560e1f99c0be4084c3b6ce86798670793d57d680fdb10f844956a75182838"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4931ff920f63af53b457df062501ec383276a3ca6e37112366e8af7f1d91b720"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b14c9917c80cdcd0772427846785b128e6f699ddf73967b8a62dd16ca3f41313"
    sha256 cellar: :any_skip_relocation, sonoma:         "1adeccb93e16506df17fc52eb30e51117466de92565b2603f8a524050c3a09d5"
    sha256 cellar: :any_skip_relocation, ventura:        "800f41a550b75520646988d66baa374e547943464249510fd4a666a5ef770599"
    sha256 cellar: :any_skip_relocation, monterey:       "61450c867f949acf3754b9aa63cb4122a89ff653648a1732e5627e126437dbaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfde3fd68642f5f243a853c5fdbea3844db1fa7d55176c573b83b80b7c0641f3"
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
