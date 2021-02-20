class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.14.0.tar.gz"
  sha256 "2795720f35994710094847990234da8d38e6e43f0810b69c6f45087547d2a4d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6aafff30563385ae2c4b05e97542ef1cc480047eae6c0cb0f42a07484fc51352"
    sha256 cellar: :any_skip_relocation, big_sur:       "b802e6cbd858c87266efb94ed7d7eff99bc21d433346cb8264723a4543591914"
    sha256 cellar: :any_skip_relocation, catalina:      "13a90656910ed0cb6f31cdad54c5205a758d55ea7ba9d6fde1e20519853d1571"
    sha256 cellar: :any_skip_relocation, mojave:        "67de10b9c2c3aedcaca4c44bcfb40e289371be4bea9b5ee5d3418c6101d5d89a"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
