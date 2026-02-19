class Credo < Formula
  desc "Static code analysis tool for the Elixir"
  homepage "https://github.com/rrrene/credo"
  url "https://github.com/rrrene/credo/archive/refs/tags/v1.7.16.tar.gz"
  sha256 "acd482a2c13a210b7e0c625deaf30343bb1b5a0d376495390cfafe4791bc5b89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1f5ee2032d58f36bb76a51cf44b8f0eacb7abeed55cf331bc22901cad80a25f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1d60a5b1d5a3b6034d4ef44c96b3b0ae5b2aad0c434c05c9a30c59860db5165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f29d410acec555357247428e5b76fb60dac477c4ef23a7774a9c211963291ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf387bbebff19e66b40e087b63ebdb736eb1b5ab0ff4f05f65464c417a54e333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1ba41867857071d5455abd22d4e05f2015aa46e1cb7576da176f1d77e7669f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13fe235ea81057338db4aabb833261e05e67e96abddd630bf74f475fb059d468"
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
