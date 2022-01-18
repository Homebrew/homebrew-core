class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/1.1.0.tar.gz"
  sha256 "4afa3629f95997449ec9ce15a4aa59dd8fece5a5320e23e1d1c7590d1831d953"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

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
