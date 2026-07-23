class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "933f2a492815300dc9a8f785bdf00d9701d6468934b61118baa09e0d6cffc11b"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "380204e3e1075f94c6653c523e83023eca07ecff67df6ca39093a11b8900f146"
    sha256 cellar: :any, arm64_sequoia: "60fc680a78affc658d2099784a67e1994a81425a9a9c19ed5eb51bc608c435e7"
    sha256 cellar: :any, arm64_sonoma:  "0a1fcc0abd140536afc08b3cbf7f0bd3dabf82e6727783dbaea30e9f70cd97f4"
    sha256 cellar: :any, sonoma:        "d578324fe6c7d16ae5879994df52579aa27693e6ad697a6cbf35adb1099d8433"
    sha256 cellar: :any, arm64_linux:   "65e8b1862a669ec5a0c6dc861ffabe17ccf886ab32295b80959add232365fac1"
    sha256 cellar: :any, x86_64_linux:  "710f53307aaa629b0b79b7f333f828e82de5aabe8c9cc52af138e3570ff4da81"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "just" => :build
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "mix", "local.hex", "--force", "--if-missing"
    system "mix", "local.rebar", "--force", "--if-missing"

    # Drop wx/observer to avoid pulling wxwidgets/mesa/llvm; see https://github.com/expert-lsp/expert/issues/786
    inreplace "apps/expert/mix.exs", ", :wx, :observer,", ","

    system "just", "install", "--prefix=#{prefix}"
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

    Open3.popen3(bin/"expert", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
