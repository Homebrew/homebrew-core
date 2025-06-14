class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/4.1.0.tar.gz"
  sha256 "a4b0eef813cf78a01c42fc35c2b92823827bdb08f7d25a0501d47851e20feac2"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45f2f24cba2eee14657d5dcd506a17f1c390b2852167b182c499c8d88bf6d1d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57fd33fad71ef8df24ac6bb12c3310c4cd696bbc06e505ebc1034d2b3eab2060"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "338e0d17ca455bcbce9b7b0f3321395d8e215bb327b04a61519142a5266b3b3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cc48cdbb6cd8a7cfde77485584b33f1bb0ec154429704755a699ae7bb5b3660"
    sha256 cellar: :any_skip_relocation, ventura:       "b9d563bc12f2c6ec7bf4d0e6ca63598364182234533aea7e6900a72b75f48ad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "219efa789dbf8ca9907ffffbe13e12a6bdc525f14e03ceee68241909d3a9ba7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7cd0a2ec4b75fb6c968986603e39eb21e8eb968dc2833fee4fd9f88f797c94f"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "escriptize"

    bin.install "_build/default/bin/elvis"

    bash_completion.install "priv/bash_completion/elvis"
    zsh_completion.install "priv/zsh_completion/_elvis"
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
