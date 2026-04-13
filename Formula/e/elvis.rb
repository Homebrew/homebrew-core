class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/5.0.3.tar.gz"
  sha256 "566671030530eaea956bac23c00c6f9bb3c457c2b108cb5eb58ff8525a4da3fa"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25fee71b769b7e51f69c59ec6e489ed18f015be9325b78ebf29057f6bf8cc232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991d17518c60f3b5a94a38ccb9170bcfc9e49921981d981488bff44ef230d516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95c4946de65c59ad6121410186968a92d36faa33c4ed605d4b20359f18770e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca8e1fd4a78784df451215fc8dff53f2c526e88c076c28cb6c0c71f90bc79f76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "052f0db6cb1c42742731640d151c92958914b177372124cdb6fe01c134877154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0f555176aeff4368ff842b421a656ef4e713ca292ed5e580650d97c2bb4e76"
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
