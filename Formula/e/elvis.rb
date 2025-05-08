class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/4.0.0-otp24.tar.gz"
  version "4.0.0-otp24"
  sha256 "e36bb816ae606bfd03305c1fbb178abd6e9fa004cb353bc96c5572c3738f7c8d"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e4dba522149c736bbc8c34e5781fe88e6106bd52e5bf9c7407b9b7601d95e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a46b817c87c987b2b89727e147eee163de8a8abce66aa1fefccde776f996280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c2d63a6bec20b6f56016896e0a82ad728aad29b7947b5fa8ba0dc8a591dc516"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b4c1157fc7c78ba4162ad253e1efe248ecb6db28d0de4d4686612b5577a009f"
    sha256 cellar: :any_skip_relocation, ventura:       "847802a72846f3f28bd9becbdd1ca71ab6e3cdb9fbd9ca71ff0720434ff0a848"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b22f7fa8863daa1f9e00b1673d64b82a6669eaaca85e9478648e5dd6a7ba2c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe85e89a5e28c9539d2702d486f630749b4e7f61a6fb99edc0cfedbe4ad11a0"
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
