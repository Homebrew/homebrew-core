class Proper < Formula
  desc "QuickCheck-inspired property-based testing tool for Erlang"
  homepage "https://proper-testing.github.io"
  url "https://github.com/proper-testing/proper/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "68fcc3b23ea98537d7a2b926de688dc347e02804c54d0f8d79ca7092c9456b68"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dd4b207dc41e3788810712f20a50c614ce31ccafa0d309dbac29fc4f1cc8d1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a639af1f2fb8cb688b919b54037d671b65ecc5ae791ddd8d73ba115af86e135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a9399e52a16770d3d839cab3d68e563e6d5cdfa978c9fbaefd3681799d64358"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ebfd48008cf6e2414fd327b4417dcd3f178733eb0bf4c8f482820078d606ecf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b871a437a48e0bd4f35687256c82caff38cc8ed91662daacf465638290dbad49"
    sha256 cellar: :any_skip_relocation, ventura:       "8121ebc9c4160073387dbdb7012f0c536783f811152220a7b09108ec6777886f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d95538e53374c507c624b17c23e9bc1218d83ad2a8c96006bb941681d7170be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c46ff9ea392d1503cfc49f425fd04ed35376da507fe13985306057715558924"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "make"
    prefix.install Dir["_build/default/lib/proper/ebin", "include"]
    (prefix/"proper-#{version.major_minor}").install_symlink prefix/"ebin", include
  end

  def caveats
    <<~EOS
      To use PropEr in Erlang, you may need:
        export ERL_LIBS=#{opt_prefix}/proper-#{version.major_minor}
    EOS
  end

  test do
    output = shell_output("erl -noshell -pa #{opt_prefix}/ebin -eval 'io:write(code:which(proper))' -s init stop")
    refute_equal "non_existing", output
  end
end
