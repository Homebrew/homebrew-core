class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/4.0.0.tar.gz"
  sha256 "002b4ee354b398e62cd29edc3f8ecdadef8d3cfe963bd0047e9512335e307f43"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "869ab7edf1230befdc9f7dc7cfd3c5b9374dcc95950301d52f194b941685aafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2591e0e85e7fc9b629bc1ff228c87d978e048b1b9bc2de01cce733ae3ca9e0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c45f857aad49e4a6566251d7fc18cbaf98574111f5bf77d13e28307b1cac606c"
    sha256 cellar: :any_skip_relocation, sonoma:        "73bcdae25b799793a1087f545caa5074e432361dd97b69604ebdaaf56742da31"
    sha256 cellar: :any_skip_relocation, ventura:       "f82822d583ea81ce907916f7ac5d67c6d6787c160406bf097a56675f53779416"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b39aa4ed566bc02c07f350ff9d0a54ab040003ced3318b06d0a52f17ac27f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "640e7e5f6211bb72b71e5acb3c2bc4b34dc96c5e1e11c739955ce82f097bee24"
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
