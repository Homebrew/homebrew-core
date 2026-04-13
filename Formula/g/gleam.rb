class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "268c635591bd165e0e1d1fdf7cca9d7da141b6aff58b84a43397664cb270a870"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "509ef8036b2dc1a95f7c8e8b3f16786e0dedda1e8aa5bc66982f0459f0ba966e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f2e98d2baccab0c7d4ee124efe0fa6e84a26c00d368453693a192b9b2b705f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc08f226b8f44144b7c097c14602d406ed0b84ff295db8497e86bb3928af5931"
    sha256 cellar: :any_skip_relocation, sonoma:        "43d216ef42390145ebde23fe12f7c3d77a3b89e6ff87fe51aa1a2941fafe987a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0f30a7bffeb203d6c859bde5c5aa7d6a88a28007f2dcba4470b9f8509c1717f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0449b9721d7f3a86223ca03482d768adb9f4f0b9d69bf2bb585bf5787be15e7d"
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
