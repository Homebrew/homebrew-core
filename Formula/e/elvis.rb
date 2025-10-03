class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/4.1.1.tar.gz"
  sha256 "82a42102734285d0e39a8b55bc2195752f44347b6f2ef0962834e49579d067c8"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa95f536000cc0546c7237ac4dd7a4aadbe7b8da1f73e753b1f6a6159e6d1001"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bbbf2d22dc2579b2bf23653ca33921cf3c09c761553b48a20772e05467f00b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce6e257ad7d6a96ab10bbade74ab0874c8051c4458ea5d25aae43ba31f372e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c35cb9a8771747e803826cf85e85d3520c0ab93268ce550b7f7af7e01edc21ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fca57a53ad55377d3cb7f0bed1403ae719bcda8a822415c6b72b37cfb2e9fe9"
    sha256 cellar: :any_skip_relocation, ventura:       "e2b984f3450afb0226886466f6cbc5ee200b40c1013f40f14dada7e4d9d0d05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f6a6b39e87fb2ca468ff0af6689e405b0bef520cc2e2a64d1b078596ef8a9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e5b379a541035dc3814efdabb279e71ca90a522c2fe0e5bfd79b09e6a82ddd"
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
