class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/6.0.0.tar.gz"
  sha256 "ea0d3438062d94b686b375e98995584ed7b6b8863582f77b1966971299e400f4"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7944f413096aaee873497e06a63b29efcc90d2a6a58d6a4e38cb26cb48bfa52f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983206b5588ed463a0d0fcc6b30a65697fb61639ce1d920cf0a8cdaa0eee1a3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6b3a722fb62be43761a0eb24495fc76eb66f9b33a8bd875b8212b8b35b7abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde60b82cd915810d314b7534662b5641a2000e8078bb4b8f67c7ae851bebad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6a71c3ad39225794ffe021b07aa06d50d2c0430d574fac02626cb6cedbf41a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5311e07f8ea291a5210df67517e484beffc53b7a487a149a255c031d745fbc73"
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
