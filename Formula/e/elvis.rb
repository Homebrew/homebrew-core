class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/3.0.1.tar.gz"
  sha256 "ccf479c6d6bddc7fc9e6658eaf15f792d11e988f58417578b53e223e4f551698"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8402f637671b569fe7375bf8a3f0ea53f23a90ea40658e53b47f5ea69f8d9bf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b57c94b53cef14384be4027c8d3706fd85dd847488fdb7b4d25569a33aa574a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f05aa4cc9c917962abf625a64d67dcf7bf53af6a5a5fdfb541f2bd96e95fc2d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fa9839edd6e74ca5aa71cdc749053af571c77c439013363c8f627bc32ebdd62"
    sha256 cellar: :any_skip_relocation, sonoma:         "9699e388b2a4bed99989a066512cd9e2f6332f49bae2989e65c65d1608ab2150"
    sha256 cellar: :any_skip_relocation, ventura:        "fc401663943b73aba90c724933a73a1972b6fc35165d51e1a95f006eeac46002"
    sha256 cellar: :any_skip_relocation, monterey:       "68bfbcdc197ad8c7a3abbad35f813ee963991488591963a6c74544aacafdc1e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "17fc8a544b03e9b3c97559080380687b9d3f8c3305cfea49d3b2fefb5d23edde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a35df5889207d099e0c0f5aa97db557413d447c74a6d1b6e929fd6365a249d6b"
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
