class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/5.0.2.tar.gz"
  sha256 "a8dd3aa92da9f7a12314d3bde9241383b583f2fe5eca77c2bae477f725d2277a"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cf87c68bb955d1b9d65bbb1b2732053486e7148ae8a3908ba28831da6efbfba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13bf8e6b24e90e901a6e41afd5df15218f4957fd0bb343dabfc09cd563ffc527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db41f1ab4748593ea1737c6ea31ee51f626d17efc0f3ce610fc6b583b02ea143"
    sha256 cellar: :any_skip_relocation, sonoma:        "d02766dbc8b1f777fd2301ce80a3ead1fa54885863ed955993109b6a47db15f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f621b6628aac44d90e702ac097f6762f4f7a424bfcde477ef13209d076adcc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dafc70374b5bd621925cd7cb28e51b8398cfdbcfcdeae6339a38cf6c6da16c2e"
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
