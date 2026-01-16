class Credo < Formula
  desc "Static code analysis tool for the Elixir"
  homepage "https://github.com/rrrene/credo"
  url "https://github.com/rrrene/credo/archive/refs/tags/v1.7.15.tar.gz"
  sha256 "29ab2c89bf26d4a0884e203c99ac5de65c7a984f7121bca5a5558f4fb00b3339"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a900ea895f3491b3b89f7584a32a53a85a5853d8b2179eab67fdb42293924cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "438dcc6d3902e10596e3cae7856965255541eb9b481b9dce6da2231d66498d3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a96ff5bca1a695838efa89ab585cb622b0afe5f988a54aff8ca3b1f83123398"
    sha256 cellar: :any_skip_relocation, sonoma:        "db581e5e8358dc0cdb3bfaa2d0b881f59ff1e63e1b8550827f56d0cfe6186974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea2121402288e98feef3f40fe4a1b0322914b6e87bd0fda85a46cafdbba41151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e79faefddfb98e42ed4d2fb32f3ff173648d747315904c84dd3782a44c32c62c"
  end

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"
    ENV["MIX_HOME"] = buildpath/".mix"
    ENV["HEX_HOME"] = buildpath/".hex"

    system "mix", "deps.get", "--only", "prod"
    system "mix", "compile"
    system "mix", "escript.build"

    bin.install "credo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/credo --version")

    (testpath/"test.ex").write <<~EOS
      defmodule Test do
        @moduledoc """
        Test module for Credo.
        """
        def test_fun do
          [1, 2, 3] |> Enum.map(fn(x) -> x * x end)
        end
      end
    EOS

    assert_match "2 mods/funs, found no issues", shell_output("#{bin}/credo #{testpath}/test.ex")
  end
end
