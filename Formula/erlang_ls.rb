class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https://erlang-ls.github.io/"
  # pull from git to --version works
  url "https://github.com/erlang-ls/erlang_ls.git",
      tag:      "0.41.2",
      revision: "1d8500819002fa1a2d1969619dbbc99ca91409de"
  license "Apache-2.0"
  head "https://github.com/erlang-ls/erlang_ls.git", branch: "master"

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3("#{bin}/erlang_ls") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
