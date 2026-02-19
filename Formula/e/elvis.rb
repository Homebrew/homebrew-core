class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/4.2.1.tar.gz"
  sha256 "e63c6c4cfa0012494a0e5020b2a51bd2f8996436550efc18a5e5bac6c9fd402b"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69ad08b908112208721c2f0d0625f3d03b58ecd0a970d013ec61e50febd2569e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272f45089c544145ee92b0adf2ff3755b23a996f5e4fcdc849a00b8b58c93dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7cd7e71ef275c685ed01843a42a89fc9fc32420dbdb003d7f05e6530887bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b2ece03758d5aec0f4f4bce5086627817f4b1eabbc08daf872a4f92db744f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d21acf68f4e64b5deca94030fbcc176268af1536a5e7d0d0a93da3390ddf23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd7ef14fdca413c2a72867dc80808b7d5ac8312ec2e61417156e7f389bd03f82"
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
      At line 3, column 2, the name of macro "bad_macro_name" is not acceptable by regular expression
    EOS

    assert_match expected, shell_output("#{bin}/elvis rock", 1)
  end
end
