class Jrsonnet < Formula
  desc "Rust implementation of Jsonnet language"
  homepage "https://github.com/CertainLach/jrsonnet"
  url "https://github.com/CertainLach/jrsonnet/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "2396c57a49a20db99da17b8ddd1b0b283f1a6e7c5ae1dc94823e7503cbb6ce3f"
  license "MIT"
  head "https://github.com/CertainLach/jrsonnet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcb5b5d99df55c43c70b475ea291ee1d614b76e705be867d688f17bb22ac9842"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "583e666fb6a076a89b1d447ad9220d30409cc62e931c1f4c9dd99cfee9291252"
    sha256 cellar: :any_skip_relocation, monterey:       "3e79d3068b3c2ca7442c13fc57d8ddd85b0cbb8844c78b8a3c971f5873e3a3a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "419f0a50acd6a0cce0abbfe2131d18bdf964fe0d09a095c2c92e10b8b1fb04af"
    sha256 cellar: :any_skip_relocation, catalina:       "08a4bac487db7433903275f05ba23d11a8a8865590a23a868aa105f49416b650"
    sha256 cellar: :any_skip_relocation, mojave:         "d927e34108112f33bfa9bb6d004c3540d983ff789d6e5969a4fc9aa8cba92a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7a1bfdfe53b056dbd4cb5433fc26a47b82dde02a913a34870fc6c365a8885a"
  end

  depends_on "rust" => :build

  def install
    cd "cmds/jrsonnet" do
      system "cargo", "install", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "bash", "-")
    (bash_completion/"jrsonnet").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "zsh", "-")
    (zsh_completion/"_jrsonnet").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "fish", "-")
    (fish_completion/"jrsonnet.fish").write fish_output
  end

  test do
    assert_equal "2\n", shell_output("#{bin}/jrsonnet -e '({ x: 1, y: self.x } { x: 2 }).y'")
  end
end
