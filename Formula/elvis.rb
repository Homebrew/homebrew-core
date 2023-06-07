class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/1.1.0.tar.gz"
  sha256 "4afa3629f95997449ec9ce15a4aa59dd8fece5a5320e23e1d1c7590d1831d953"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "210984b57d5962ef212e888f437e57096523f5f69213b8d6ed955e06e12c3853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484b57c447562c600cfa29ac602785be86aa4e8b761d0876fb9c329907101a97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3368f9a7586dbb61126f781336e0cc9ccc30791c0f7b4ea2d99e7ba6ef6d1df"
    sha256 cellar: :any_skip_relocation, ventura:        "ff296bea3962c667a33530101225b5cf52bfc1f349cb935ba68b12e113afa452"
    sha256 cellar: :any_skip_relocation, monterey:       "b08e0a5e40f231fb03d6507c9cca0fdd5f4e246b6e48f979d03e9c453837db19"
    sha256 cellar: :any_skip_relocation, big_sur:        "0249893c657ebda3b0d781d485bb969da79957cad9aaca612de41ed13aba09f3"
    sha256 cellar: :any_skip_relocation, catalina:       "9c14bf947e1c2bf32b8a72385d8773262c3c344c55be92f6bd221144d3655806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a3250151dc4ab48cfe4ddcf67bb48d48b57870171e1ba9331470505bd48e42e"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "escriptize"

    bin.install "_build/default/bin/elvis"
  end

  test do
    (testpath/"src/example.erl").write <<~EOS
      -module(example).

      -define(bad_macro_name, "should be upper case").
    EOS

    (testpath/"elvis.config").write <<~EOS
      [{elvis, [
        {config, [
          \#{ dirs => ["src"], filter => "*.erl", ruleset => erl_files }
        ]},
        {output_format, parsable}
      ]}].
    EOS

    expected = <<~EOS.chomp
      The macro named "bad_macro_name" on line 3 does not respect the format defined by the regular expression
    EOS

    assert_match expected, shell_output("#{bin}/elvis rock", 1)
  end
end
