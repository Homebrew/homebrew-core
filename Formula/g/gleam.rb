class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "9955f255567b7e975505ab3633841bc0650afabd4bb31f3a337bce91e2fc29de"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41e5c98a1be5cc2e6e22be0aa0e26c5d15c892d36222711dfac7f5318659e0d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "902c039c235d4a3afe20c2ecaa835fde9fb494b5d53291a638c53bdc255e97c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f539596273fb44b0fed78000e5eed867518b1f9a91c8f8a2163000d5f236d76"
    sha256 cellar: :any_skip_relocation, sonoma:        "81fc2d568306bfffb6a6c35ae8985d3c151439bc1913e32330820c5cb59f739e"
    sha256 cellar: :any_skip_relocation, ventura:       "85746a076b92c7ef05491b2023bc7d274449f82788c1ef0e12d1b252306a1c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f67dfe40f7063e34b4689bba2782882fec9a93272d4fce4e627011a72816f6a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
