class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/3.1.0.tar.gz"
  sha256 "ce43fda618bb0d28c294414f7827df02afac374120018754a7fc96c6b44ca6b3"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a2dcf1e873e254d0e92a731075df683f231da6c55648c1c5205c9e6688823d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77cb1a9017cefbc33155cdad75985687a305d09c56a73dcb0df415fb675dae6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1648f8c1e16860aaaf980289624c2998b335e1f98bad44e30f29cc9aab4e03c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b54bdcf7b83b214cc69fdb07414648f245f42ac715cc1df8300dafeef06161d9"
    sha256 cellar: :any_skip_relocation, ventura:        "305e34cf0331e41e673b0dcbddc9822a1769e2b008d2cb926edd6b588d37f367"
    sha256 cellar: :any_skip_relocation, monterey:       "7acb786affea1b9910fedcb85654b04f6380a7b81188ac35cb54a1a65fc3be82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7f987f35c55ae198455cf19d5e721663d3ec8a55c57ab635ea0944a88ceb21"
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
