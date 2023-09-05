class Proper < Formula
  desc "QuickCheck-inspired property-based testing tool for Erlang"
  homepage "https://proper-testing.github.io"
  url "https://github.com/proper-testing/proper/archive/v1.4.tar.gz"
  sha256 "38b14926f974c849fad74b031c25e32bf581974103e7a30ec2b325990fc32334"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ba16c265d878f2385d16020577833fc18f3f34ebfacebf9806ffae99caaed6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fb7580b8ec4be37ae5eb66f3d474f5cb7134d91968b6a3ffd57e946601c3e7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77657642632df4b47ea81fe644f297b729b6727a65c14e4b55205878b7c2efa4"
    sha256 cellar: :any_skip_relocation, ventura:        "0595b2fcc45df233b568344d6169b781ea9e7c5ae95fbfb6696d77ae5fa0d5cd"
    sha256 cellar: :any_skip_relocation, monterey:       "61c38ab31cc8a971a833b3659cf7ca0907d2c3a8fe76ce9a83e17ae322154a2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "90cc29581b44ff082445a03c2955dba09000b8d4734d739764c702e6da72dda3"
    sha256 cellar: :any_skip_relocation, catalina:       "c24a2347c8832f7db7aa536c7761e1f7c24d1beecbf542feff21bc3a82ffb0fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab7d497f0decd957772de50ce1ed18da6dd4a4d4f8583fa92fbf554fc69a64e"
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
