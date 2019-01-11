class ElixirLs < Formula
  desc "Frontend-independent IDE \"smartness\" server for Elixir"
  homepage "https://github.com/JakeBecker/elixir-ls"
  url "https://github.com/JakeBecker/elixir-ls/archive/v0.2.24.tar.gz"
  sha256 "8174cd9cf5cc77a9200fcc8040fe8ddd7ad36e6c6eb914d76f2481ed73f2f4ee"

  depends_on "elixir"

  def install
    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release"

    prefix.install Dir["release/*"]
    bin.install_symlink(prefix/"language_server.sh" => "elixir-language-server", prefix/"debugger.sh" => "elixir-debugger")
  end

  test do
    begin
      io = IO.popen("#{bin}/elixir-language-server", "r+")
      io.write("\n")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)

      assert_match "Started ElixirLS", io.read
    end

    begin
      io = IO.popen("#{bin}/elixir-debugger", "r+")
      io.write("\n")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)

      assert_match "Started ElixirLS debugger", io.read
    end
  end
end
