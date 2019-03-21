class Proper < Formula
  desc "PropEr: a QuickCheck-inspired property-based testing tool for Erlang"
  homepage "https://proper-testing.github.io"
  url "https://github.com/proper-testing/proper/archive/v1.3.tar.gz"
  sha256 "7e59eeaef12c07b1e42b0891238052cd05cbead58096efdffa3413b602cd8939"

  depends_on "erlang"

  def install
    system "make"
    prefix.install Dir["ebin", "include"]
  end

  def caveats; <<~EOS
    Add the following line to your shell startup file (~/.bashrc in the case of the Bash shell):
      export ERL_LIBS=#{opt_prefix}
  EOS
  end

  test do
    assert_not_equal "non_existing", shell_output("erl -noshell -pa /usr/local/opt/proper/ebin -eval 'io:write(code:which(proper))' -s init stop")
  end
end
