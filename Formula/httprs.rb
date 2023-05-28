class Httprs < Formula
  desc "Simple and configurable command-line HTTP server"
  homepage "https://github.com/http-server-rs"
  url "https://github.com/http-server-rs/http-server/releases/latest/download/http-server_macos-latest"
  sha256 "c18c5652ab3b0931c9f7e44ec8edc5aafaea38c05c5c9bc232ee50ecc423cb8a"
  version "0.8.5"
  
  def install
    system "mv", "http-server_macos-latest", "httprs"
    bin.install "httprs"
  end
  
  test do
    assert_equal which("httprs"), opt_bin/"httprs"
    assert_predicate HOMEBREW_PREFIX/"bin/httprs", :exist?, "httprs is not pesent"
    assert_predicate HOMEBREW_PREFIX/"bin/httprs", :executable?, "httprs is not executable"
  end
end
