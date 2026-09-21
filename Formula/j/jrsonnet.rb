class Jrsonnet < Formula
  desc "Rust implementation of Jsonnet language"
  homepage "https://github.com/deltarocks/jrsonnet"
  url "https://github.com/deltarocks/jrsonnet/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "2396c57a49a20db99da17b8ddd1b0b283f1a6e7c5ae1dc94823e7503cbb6ce3f"
  license "MIT"
  head "https://github.com/deltarocks/jrsonnet.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82d5b24d2553147fc34a7c36a9a0fa2de7e4a6db99bc21b9695529ddfd7c20ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb53f849aa5359474ccf9503d1c6a6ac9fb48090ac9d179dd46447d1eaa1eb0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94ee1130ef46c19c4de00aa49fa41b50303af407669bd8d28d179046fa995dce"
    sha256 cellar: :any,                 arm64_linux:       "c1ce6e57cd1099221d040e7d11c322dd843986e9a168ce472a1eb25875f137b9"
    sha256 cellar: :any,                 x86_64_linux:      "7ce96b7714531828e32377681c6400f477e70e799a22f1ba232a05added276aa"
  end

  depends_on "rust" => :build

  def install
    # TODO: `throw!` macro trips `semicolon_in_expressions_from_macros`, deny-by-default since Rust 1.91
    ENV.append_to_rustflags "--allow semicolon_in_expressions_from_macros"

    system "cargo", "install", *std_cargo_args(path: "cmds/jrsonnet")
    if build.head?
      generate_completions_from_executable(bin/"jrsonnet", "generate")
    else
      generate_completions_from_executable(bin/"jrsonnet", "-", "--generate")
    end
  end

  test do
    assert_equal "2\n", shell_output("#{bin}/jrsonnet -e '({ x: 1, y: self.x } { x: 2 }).y'")
  end
end
