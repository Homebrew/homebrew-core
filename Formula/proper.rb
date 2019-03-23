class Proper < Formula
  desc "QuickCheck-inspired property-based testing tool for Erlang"
  homepage "https://proper-testing.github.io"
  url "https://github.com/proper-testing/proper/archive/v1.3.tar.gz"
  sha256 "7e59eeaef12c07b1e42b0891238052cd05cbead58096efdffa3413b602cd8939"

  depends_on "erlang"

  def install
    system "make"
    prefix.install Dir["ebin", "include"]
  end

  test do
    output = shell_output("erl -noshell -pa #{opt_prefix}/ebin -eval 'io:write(code:which(proper))' -s init stop")
    assert_not_equal "non_existing", output
  end
end
