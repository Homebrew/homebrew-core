class Credo < Formula
  desc "Static code analysis tool for the Elixir"
  homepage "https://github.com/rrrene/credo"
  url "https://github.com/rrrene/credo/archive/refs/tags/v1.7.19.tar.gz"
  sha256 "a4b5a14d574107e1e17857f699584e332f8553cdf465b8d1b0307c4a63c60af5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4f03983a52bfb2685befc67359c58fe72e89494a138a7958a80de8dc236d327"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37378aca16a01f33c71c2a1cf5ae810f2988dfac5aa920c916614d34b63afcee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41aef431478b7d37fb76857b4061d053ebafd34d5b906ff89495695df2fbdd11"
    sha256 cellar: :any_skip_relocation, sonoma:        "42811b551a0aaa0f3bc0d14b2c92e5f324bd7df9a6a15887ca3ecd314e0d8880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d46a695ed4be43bc7fe66c60c3e028965f1b786d13887dc8ebe9ea87a72b368d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9485206192d9b19d1de67610b147c9c89a4b095ea40338c16b868000528f9075"
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

    (testpath/"test.ex").write <<~ELIXIR
      defmodule Test do
        @moduledoc """
        Test module for Credo.
        """
        def test_fun do
          [1, 2, 3] |> Enum.map(fn(x) -> x * x end)
        end
      end
    ELIXIR

    assert_match "2 mods/funs, found no issues", shell_output("#{bin}/credo #{testpath}/test.ex")
  end
end
