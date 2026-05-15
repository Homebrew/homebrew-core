class Credo < Formula
  desc "Static code analysis tool for the Elixir"
  homepage "https://github.com/rrrene/credo"
  url "https://github.com/rrrene/credo/archive/refs/tags/v1.7.18.tar.gz"
  sha256 "d695860a3dd84682cadf8428aeb3c601ff2aab0c46c93d5c8b4d73804c384bdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a1ef0e5ab383ad65d5d7143664364c342653d9cbc0081a94e34581aa2af3b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81393d6ae26e5c6a4f779658612bd1ded873a9a835ecf5bcd877ff5a55faf8db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56cdae9a6197b0bbfe2051c315f757d108140767450eab83dd05b07ba5257f0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "efcf774688cf605608bde397d5c392dede34c51fd58083abf5dc894160560ea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0060c9f6fac1e6481751f87efbf4ae00920ac81f547c5f53983cea1b8a6c2121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4dadb66bece4ec69f99523250ae8b256741ccf99d92de342807e3e6037992c"
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
