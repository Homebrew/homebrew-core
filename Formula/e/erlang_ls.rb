class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https://erlang-ls.github.io/"
  url "https://github.com/erlang-ls/erlang_ls/archive/refs/tags/0.51.0.tar.gz"
  sha256 "1eb8748755b2990d02e8ba8387f6f9ef04c398ad2975fa606387f3b9bdbafd1c"
  license "Apache-2.0"

  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/erlang_ls", nil, 1)
    assert_match "Content-Length", output
  end
end
