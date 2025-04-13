class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "eacf88d2ce6f7ca06e9a0d6b8117c517a8a21593349233edb2506263d08a830f"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ec0afbc6f08c642388c722bc050928fe2f17b4eeb6d0ad5a388fed1ff528d43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "390f479db9dde8045cf75eb457cc6bbf5531ea7936efdb61f6076b55ddaee30b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2673a3dce74885d41fcb34383aa8769b956078131486352f27298a7a0287d340"
    sha256 cellar: :any_skip_relocation, sonoma:        "e44a77d4448a7918c8f0de0b1a94749499c05e70510978997a3545a2dcb4bc14"
    sha256 cellar: :any_skip_relocation, ventura:       "d1fbae3f9c47c248ee842b077a2b889066b69c9d30e4b090f78835f24a07353f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154cd4761e911f7a690eff52792c967220f5fdcb7c7f5472e20f7213d8a055a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0cc54b9c4959697921c9f3624d9dde3e9f8714455c40a4e6ad3a3bf587d6914"
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
