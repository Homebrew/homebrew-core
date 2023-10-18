class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "5fcbbb8a35448f12086ada4942cdb2f10338a5c95b0fa2b8471b5cbdf257812e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a8aa1474647e30e5e1ec2f4c007881f3d6f6937e929a9a13d6a12ee75a72607"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54589f156f0cd73a7e9138cb22118ccd97eb70e98bf4cf4889e75d36d25434dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6b3f18dd14e39009c3346ea4392f010fd587cc880db513aab9e586d11425b0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "441e5bcce12575597b33c54848f3ab9daf99bcfd79a3868c62c8b6d459d9e80e"
    sha256 cellar: :any_skip_relocation, ventura:        "1d85fabfa9c6e16e9460aaf639ded792e188e4b18d54e51babb709b4028c2cee"
    sha256 cellar: :any_skip_relocation, monterey:       "d471fa3d718c462f482531f729fe6e0bdc6d0e5060737c74db58ec24b3d6b30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3584eca7260ebfd081fd2563ba5e84d6cc3fe52f097960e36e4c04827d152feb"
  end

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release", "-o", libexec

    bin.install_symlink libexec/"language_server.sh" => "elixir-ls"
  end

  test do
    assert_predicate bin/"elixir-ls", :exist?
    system "mix", "local.hex", "--force"

    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/elixir-ls", input, 0)
    assert_match "Content-Length", output
  end
end
