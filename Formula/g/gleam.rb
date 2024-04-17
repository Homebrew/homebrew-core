class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "472fb4725fd1c052a7a884eec3c0e5fd9d423a9f01303f3227e65025ec9b7c42"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2da3ae9fd033d3596bf09ed72e9d5550630054beade057ad957a04814482acde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70bc872b6625601fb788c6c6bc9a0e0c2941d5ad4b679bc601aad9ac162cf2c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0ba58393d30e15ea50da252d2bfabf80f1a006019859828528f3b3639f6cfee"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0c890c924f1871b97d09f28c7d0b7ab3e17a4ddac5de0cbadef110a8f6101ba"
    sha256 cellar: :any_skip_relocation, ventura:        "4cd7edf2f08f740cff070e2f896496c8b65d178e360a19dd1e0a36e4529ed181"
    sha256 cellar: :any_skip_relocation, monterey:       "0d20b2184091fba55c76becb2a3464f105ee5a1c999021178270d1393aee0dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d62ec86535cefaeffdcf84cccf9b17688a8ba05d264f04f3b24812bc9b2c135"
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
