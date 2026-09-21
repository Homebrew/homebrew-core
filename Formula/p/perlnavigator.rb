class Perlnavigator < Formula
  desc "Perl language server"
  homepage "https://github.com/bscan/PerlNavigator"
  url "https://registry.npmjs.org/perlnavigator-server/-/perlnavigator-server-0.8.20.tgz"
  sha256 "2e50dead7e169f865902ef6e447761705f9ef07b89df0bc5b754ff3d484112db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e34b1d6b98969c6760f25f6978609183c2bba021c46e44fee2c70b003df94f7b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "open3"

    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  { rootUri: nil, capabilities: {} },
    }.to_json

    Open3.popen3(bin/"perlnavigator", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{request.bytesize}\r\n\r\n#{request}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
