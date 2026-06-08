class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/5.0.4.tar.gz"
  sha256 "d4326c8c8c753274db207a384e1751dda40ea71ef586e9688c134e05d52c3fcb"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2b3fde99a5b6cf1a25a61caf877ba77f067a3df7162552b5df2edb9fade39e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b64c33563f4c4f1a9cb6605c13b5416ef0a3dcc7f5afb80c8ff77100117ea360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16453bc7eb918fe755262aa64af5ca8f7e6d25052d473a0d870a0e9eccffbff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "158c15e1673c21f3b516035286e29d255f2207a5ae55ea5427c7373ba0b26687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "426b1a66a9fcb647261838b47dc1ea9e21605c9e5d176ed9f5a93a30d3c03457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "403a0286a0fef2aa36facf7afd20ace43d5ded29e38725c6d7e28d20946152f5"
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
