class Httprs < Formula
  desc "Simple and configurable command-line HTTP server"
  homepage "https://github.com/http-server-rs"
  url "https://github.com/http-server-rs/http-server.git",
       tag:      "v0.8.5",
       revision: "2374c3281e53f7e98c17079728e6bf70b8c8241d"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--path", "./"
    mv "~/.cargo/bin/http-server", HOMEBREW_PREFIX/"bin/httprs"
  end

  test do
    assert_equal which("httprs"), opt_bin/"httprs"
    assert_predicate HOMEBREW_PREFIX/"bin/httprs", :exist?, "httprs is not pesent"
    assert_predicate HOMEBREW_PREFIX/"bin/httprs", :executable?, "httprs is not executable"
  end
end
