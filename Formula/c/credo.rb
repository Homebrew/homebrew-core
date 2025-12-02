class Credo < Formula
  desc "Static code analysis tool for the Elixir"
  homepage "https://github.com/rrrene/credo"
  url "https://github.com/rrrene/credo/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "4ff5f180dfd409515022279e958a6fa850ea13f2f08a791bf00e60ff6f6d71ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39e46879f9ea4764f90b4f0c1c79834bc8beaf7cdb7e37243b6f5419375e6049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6adcd7ff6199850cf9a5d76c1e380e36dbf75755ed65f0b27f0e115d09b17f36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3324fb4c7f5714d79b694f64d99dbd085d8aa8a82bd97999e90bff16916cc5be"
    sha256 cellar: :any_skip_relocation, sonoma:        "e77dbf278bffc312bfab28e1d89fd1882a42f36c6b9eddfc9b6b6b135731f12e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8844c175f77115ccb788ec74fad1463076d4440cb883d5777a6c5ba43d1d0f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a64beeaef44f288d7fa8f8f11b8dbe9b1618993effcc1f494609eb0fc0d4bf2"
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
