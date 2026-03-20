class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "6fe365a52660d854a73d56e0752fc9ff47fdaa19b0ddc9edbcaa1fb935685eca"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "799c946d0df7a6b0eb36818c8ac7623f5041651893de17a8b1509e92c5cfa44f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a57a1cc3950f56197c6edfc49a17c97fe979e306f38c74107155424a289f33d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a5648783f20ec1f88c36b43669f1bf3ece467e7d663ebb88f845d6f915f4a3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b45c4af69058ab5cf7b4cb940fed8943a71a12dee983e71bc240a45e385cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fb94fd21ed2f76f4cd553b79d63c6b7e0e7366d77b656e580bb11d502ab74bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdaf1930d7191b7230f48d0895d1390ecc55d7ef871e88e9108f032fe793911d"
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
