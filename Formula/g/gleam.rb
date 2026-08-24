class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "0691b50bd3592a549abbbd7a0dea4b11f8930988c1e398d1d1429faf48933a3c"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a44cf0cd4a6022dbd65c53665f99ef4e66c98fc9b948ce158f3e20b1ab70e924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d55fa9cf855fd0fbaaa888bbf5e106cbcf56e47b7fad3f02a7742165732d0271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4604dbc9122c35ccd57d45a649b098939519cb5b513df418f9b20ce068920686"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e1e7f30815680fcc8ff53ff441f31afd8e2e0d7f4b07a5d2f3674829fcee41"
    sha256 cellar: :any,                 arm64_linux:   "228e00e8144265c2993526d436620e2e2dad86fcd69b562664fc7c6df817d519"
    sha256 cellar: :any,                 x86_64_linux:  "497f6912ef7cdae4e0db89acfe4bbb4314649265983dfdc5634b974493f5b2ae"
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
