class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "644db4b25596d5f27f03614ef1cc10646baaabbd559407acc278bb24c6502f8b"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "585f403e0a65db4f6f482e9a97674ff2b194ca809a435fa9c65a71b4130d6fc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7f2a06750c95ebf631e597b060a75b1ac3dd8ee9a8c4392bae8bade8ebc409d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67463da57d2e0ef20c95ac6ce2caf5a0b956b5cb4fe5b30bafdb296c73431ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd42ef1b822eea0aa825e637ef87d9a630d91cf69ddfaecbab6ecfe6cad71ac7"
    sha256 cellar: :any,                 arm64_linux:   "d62c36643bafe10ed3ddb2392f3ef35fde0042cde3e3a7b0aa9c3eb1fdd701f7"
    sha256 cellar: :any,                 x86_64_linux:  "297914731b1a224474b315ca7828ccf22e8adf4f5d92379b3d02242e5378d707"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
