class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https://erlang-ls.github.io/"
  url "https://github.com/erlang-ls/erlang_ls/archive/refs/tags/0.21.2.tar.gz"
  sha256 "8a0466f525091a483401a958c6c1f85cd3203c6103b0fbabf784be449031b42c"
  license "Apache-2.0"

  depends_on "erlang@22" => :build
  depends_on "erlang"

  resource "rebar3" do
    url "https://github.com/erlang/rebar3/releases/download/3.18.0/rebar3"
    sha256 "f3e2641be923ce23076ce4843ee61c63fb392bc6c44dc9d129e4b31f7e136ff0"
  end

  def install
    resource("rebar3").stage buildpath

    chmod "+x", buildpath/"rebar3"

    ENV.append_path "PATH", buildpath

    resource_files = [
      "apps/els_lsp/src/els_lsp.app.src",
      "apps/els_dap/src/els_dap.app.src",
    ]

    resource_files.each do |file_name|
      inreplace(file_name) { |f| f.gsub!("{vsn, git}", "{vsn, \"#{version}\"}") }
    end

    system "make"
    bin.install "_build/default/bin/erlang_ls"
    bin.install "_build/dap/bin/els_dap"
  end

  test do
    # assert_match "Version: #{VERSION}", shell_output("#{bin}/erlang_ls -v")
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/erlang_ls", input, 0)
    assert_match "Content-Length", output
  end
end
