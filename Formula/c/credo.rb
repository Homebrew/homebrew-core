class Credo < Formula
  desc "Static code analysis tool for the Elixir"
  homepage "https://github.com/rrrene/credo"
  url "https://github.com/rrrene/credo/archive/refs/tags/v1.7.17.tar.gz"
  sha256 "055e09afb0457583401f6d956aa9c3d7fb00dfb1243556a09080ba73bdeab070"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "246a210fd1132ca7cd40cfb33271aff91f83bdc057a2c8d9d6e63bba35a49d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4788ed60be41724167b5b7a865d3df5da0b609b42f40404d6e5f125380c1a364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e819990706515bf67d6ffe1fa5f1872f4ce9fe47b100d6fa1ed28d3e8589fa9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b26902ec516a19c7cad61a3b784eed7259bf2b703f27280db0ddb7ab78d3f1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17d4a16b32494feed28318310d9198a34b80a6bf50ffa87a02cf9dc6fba3c90b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9dad2d7c8405ecc6d79b0dc25926072abfc095e649e9f7c9627ec080638910"
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
