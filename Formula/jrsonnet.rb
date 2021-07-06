class Jrsonnet < Formula
  desc "Rust implementation of Jsonnet language"
  homepage "https://github.com/CertainLach/jrsonnet"
  url "https://github.com/CertainLach/jrsonnet/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "f35d4c2ed7a1efada7768deadb5c7509e71846844d14108d68334db9d10645fb"
  license "MIT"
  head "https://github.com/CertainLach/jrsonnet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ecc44b14e9e1d6b12ef3eab6f8d90930d5671d099b19b6242d790077ca986139"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2578d9a53ff9449f8673fe75e448d9d94f63275047d91be2b9ff8fd00a53730"
    sha256 cellar: :any_skip_relocation, catalina:      "5fdb422182ccecaae6e07e654efc7a9cf612e251c2ecf1c16427d2edec4f64b5"
    sha256 cellar: :any_skip_relocation, mojave:        "70f069a8f7fc8d73ed57c30efa82b4351068c32c73ac915eb540618450cdbecc"
  end

  depends_on "rust" => :build

  def install
    cd "cmds/jrsonnet" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal "2\n", shell_output("#{bin}/jrsonnet -e '({ x: 1, y: self.x } { x: 2 }).y'")
  end
end
