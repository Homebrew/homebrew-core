class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0efc8e21eaf5ac57948c8bdb4e772382aa0d45311fd26f2e913f1774228a1676"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c6d8ad459566cddd256ffebe7155c3079b439e73f77bb6a94de3fe61fe02d5d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "117aae11da97a130e1175276b8cfb44a9239d202df63fd4ac38c5b762ada338a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87e668d41968d796e297759ab784fa89014989ee2401438078e4e91d1c7d7fbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6892b0162b7535f46a1a2f6548c8f8ade0c5414b40bd559370300b087728f11"
    sha256 cellar: :any_skip_relocation, sonoma:         "b589f0d8df7ebfa9930653bbb3f98e80facfe903c063c2b6d59904ad471068b5"
    sha256 cellar: :any_skip_relocation, ventura:        "0b3973216a2daeea5e5a4c608846a68fbb081df05f58d30888ec7a255a27c611"
    sha256 cellar: :any_skip_relocation, monterey:       "bff7212615286e8fc15fa626d650a31624e3e3829e02e92707b216026e53ca9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15c0cdfc4893aa599df17e330d78e5193a5c11aad2a370b4f055f7ccc674492"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

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

    ret_status = OS.mac? ? 1 : 0
    output = shell_output(bin/"flowpipe mod list 2>&1", ret_status)
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end
