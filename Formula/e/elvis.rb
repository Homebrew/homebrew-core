class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/5.0.1.tar.gz"
  sha256 "fde07d4452ef8186f35a1001b1ab2303858ebdff0987155f2c7503073a8d9ffe"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15464bcec9046c105cb7d59884ea4449c24ab6680170dbe32feec932139abd76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "194a2e08abb3bd3644f38222f49a3a1796a283601c7b3ab6b5de38e31a394d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6dc41ad543b9cd1529959ce8b9bef55648a4c9a8e81030657dcab6adc74fcc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "382d4560f33cf1ad7a3733615a21942953f9917a275d4919e11c16866ec0cc72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40c44ba0eee651bda45d920663ff6adeabf3a455d7ac4bbf4231754865267bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4121f23617023448a6131582ead21bbf7015cbc7eb070a127bd0d64b4f482ec"
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
    (testpath/"src/example.erl").write <<~ERLANG
      -module(example).

      -define(bad_macro_name, "should be upper case").
    ERLANG

    (testpath/"elvis.config").write <<~CONFIG
      [
        {config, [
          \#{
            files => ["src/*.erl"],
            ruleset => erl_files
          }
        ]},
        {output_format, parsable}
      ].
    CONFIG

    expected = <<~EOS.chomp
      At line 3, column 2, the name of macro "bad_macro_name" is not acceptable by regular expression
    EOS

    assert_match expected, shell_output("#{bin}/elvis rock", 1)
  end
end
