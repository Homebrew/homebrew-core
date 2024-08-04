class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "1a3826d2d36f5442be34ec749895b03ed1538ef28e59b0134ff4001468f095f7"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "078d0f9059b0212f80640d5c8fc808a9d79286d8e3975a607223d59e8b173238"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "045c1be55b12b71ddf2d3e99e1c7abc4e5bf080a45e8eab02503ce63be53f3b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1362e71fb602d54787209a7cf697a5d4955408b4c4fce2ae2d04cd481d70fcd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "dca4ad782629279401558b6d6facc423a4213e8c341fa55b84125f7ea756832d"
    sha256 cellar: :any_skip_relocation, ventura:        "23845f27a4360739e825c7254445bd233ade9fb4ca418d20f45b2582e95e18de"
    sha256 cellar: :any_skip_relocation, monterey:       "7dc7e4cad455bf274fc75a7e6af4e0af1f3057bfe83d58582b2c4055784184b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61fd76b1898aab487d851b32376a87f453782cfc1ff03d6bbb6f8921dcde7200"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

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
