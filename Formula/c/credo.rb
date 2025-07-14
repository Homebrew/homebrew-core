class Credo < Formula
  desc "Static code analysis tool for the Elixir"
  homepage "https://github.com/rrrene/credo"
  url "https://github.com/rrrene/credo/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "afdfb4e52fa073b3279c75d70a084d3813ee6966a45d1534557275eb240fd031"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2202461e928dc327cd6c9091d101d01c6af69f0c36694715e8ad197c46bcfd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3559b14f3879fa808a3b9b4627ab651961ca458c834e610f62afec5e1d6fac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ec792d16fc50575210d6c39dbd8d8050e5419301d812fa1737296cdbafc9f82"
    sha256 cellar: :any_skip_relocation, sonoma:        "416fb36180b102c060e609abeb34b7f9f32d724f6441f50147349aed5b5c7d40"
    sha256 cellar: :any_skip_relocation, ventura:       "359a109782523caf92cc762c48bed624a5158ae612c069f856c3cfc7856611a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34443d33656e3b6e74346cf5ae840ed0daf51f0b896aab37e335debd488dd587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440e68f8e561da08116cbc9e2e961f21e459441d65d2ac2bea73c52deca4b5de"
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
