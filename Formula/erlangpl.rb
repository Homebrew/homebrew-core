class Erlangpl < Formula
  desc "Tool for developers working with systems running on the Erlang VM (BEAM). It helps with performance analysis."
  homepage "http://www.erlang.pl/"
  url "https://github.com/erlanglab/erlangpl/releases/download/0.7.0/erlangpl.tar.gz"
  sha256 "f67c85024300a958e4ee582b24b87bee25a3f4a2325d7190585611212f4f8191"

  depends_on "erlang"

  def install
    bin.install "erlangpl" => "erlangpl"
  end

  test do
    system "#{bin}/erlangpl", "--version"
  end
end
