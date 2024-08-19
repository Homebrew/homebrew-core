class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/3.2.5.tar.gz"
  sha256 "d5e606009bb2d5e535a97c0ed9242f95910163447381d90a3b2ea92669694672"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7f9111c73fa741d40c21d07f0c5cb7411f74456200d565b566eb7b4b5d639a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9db2d9c74d6a759d7d186aaa2ddbf6d0ed800bbce3446a48bff8b5c9198e0af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d13803656fed62a3464ff0d5a62d887322c6ef7e655d13d9c0ee80fad350864"
    sha256 cellar: :any_skip_relocation, sonoma:         "245955f0758d89d1b3fcd9c77c8468951a95a46f794488da1f4470b4dd4366be"
    sha256 cellar: :any_skip_relocation, ventura:        "9525c2aedc0b0ea4a95bff2d36cd30f779d0f6581edc40bbb7514b5db94dcd38"
    sha256 cellar: :any_skip_relocation, monterey:       "d71510d9b011e7c6266264fe34b4a86faf4f5b57065cf95b3f38d1c11662f53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "427f6c74dd17899542862787c271e61486513f1817ff049fa62385c042f40dc4"
  end

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
