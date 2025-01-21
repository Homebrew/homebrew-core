class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/3.2.6.tar.gz"
  sha256 "55edcd5c0c995b3c093c83f51bce1f00ea4d3322234531e03b6181a99cb42ff9"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c294e25fa6cebdfb3bfb99d34018d6a24dccdacc7f0cb52b521c1a6ab3fb0c63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e14ca75d06019d005cca1c6f1519742a3194176e57aafec3ffb5cc914293984"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3098513d6bbb4cf61672d57c6949816db49d7335b5f8db683a504b4bab020b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e8af221781d3edec43170f5291c11bd1d12e5b9b784eb9fa4ce43152f7cba06"
    sha256 cellar: :any_skip_relocation, ventura:       "4e7fe17f8a2cbe5198095ca431331f68e56e641b1192eef4f74bf953349fce21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd362818e6ddbb536713dc715923e2fd82e26549209629bbf2bf2647dce431b7"
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
