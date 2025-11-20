class Credo < Formula
  desc "Static code analysis tool for the Elixir"
  homepage "https://github.com/rrrene/credo"
  url "https://github.com/rrrene/credo/archive/refs/tags/v1.7.13.tar.gz"
  sha256 "ca18ed9ac620e4b4a98e0f5a6de8f1d42392044c379ed1a0e78dfc8d527a4c8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d29c8c19d86bd860c27cb32695834f3bbacb358d6fcf5362813ef776834316"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a96ad392fd102d2744382c4210c84ee1b1f09d14ca7e5b711b674a333f98b0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e199a5d1557a339b0948553811812506394f31f4d50aa2dd1f09ac294aafa496"
    sha256 cellar: :any_skip_relocation, sonoma:        "dee7856f05b7b654cf02f50d4297cb77cd6b1c2be655a0a529a2b1143c5ecd82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d2127b0a2b23a7507de9f7928feb17dd78ba9a3f82d66f7b8b03bb89d10f19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0388d189d43aa6b20a7937caf2cfdab48eb5f12ae390d2e9a4d53493451100b9"
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
