class Erlangpl < Formula
  desc "Tool for developers working with systems on the Erlang VM (BEAM)."
  homepage "http://www.erlang.pl/"
  url "https://github.com/erlanglab/erlangpl/releases/download/0.7.0/erlangpl.tar.gz"
  sha256 "f67c85024300a958e4ee582b24b87bee25a3f4a2325d7190585611212f4f8191"

  bottle :unneeded

  depends_on "erlang"

  def install
    bin.install "erlangpl"
  end

  test do
    system "erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
    # Erlang Perf Lab required Erlang/Elixir node to be presetn event with only
    # --version or --help commands so we're testing if erlang is present since
    # we're depending on it
    # system "#{bin}/erlangpl -n e@127.0.0.1 -c epl"
  end
end
