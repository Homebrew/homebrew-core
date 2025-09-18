class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.52/nmstate-2.2.52.tar.gz"
  sha256 "d53b314795fab42cfed37ab71f531229b6e863626270026b3d33d22c9d43bf14"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dffbe3475c5266abe44abb8074dea6997a959f90dfbf43976bac5826610281dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6544fca0494f7c67921748806a91233ac45fabb19041ebb878277024d531c965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6ab35ffee79f02f909fa624c870734fef0062c8cb9db723cffba502a3d83be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7f43ae9a97fba05f9d3750e093a59147abe0e35ffccb8d50ee0dc6edd0da6e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55428a0dd5145b2e125d360cf329183fc8d89111ebc55fd031960ba80b19de8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522d32d3aec932f51d7214ebcf11b22e2b86f59605ab6fc4567a52664fd6bd7f"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
