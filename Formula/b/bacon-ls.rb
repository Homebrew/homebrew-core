class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.28.0.tar.gz"
  sha256 "708c6c938a312d364fc249ba8e550176d9233cf93d44d87b4db73be0217c51c5"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cd85fb51535c1356942a92a88654fca0e02fdacb6d989d8d1fcb4360ccea794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e33200233bf6f3939931a2fb8b7d17efd888015ba0e574e65dfa773f191334d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a7032413c79800bdb1c70ddd9e23188ba9b560f29e64da1c406a35101143519"
    sha256 cellar: :any_skip_relocation, sonoma:        "f238758092ef54c146cca24b2cf34ea606289e322cd0c8ae871c2c53e3817009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "806d5639d85eb148c1f238ccd446de45c57e88d462981f39b1269b6e19d33304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40ee8f6fb4d59c5864acbb78028309494cbef9b583659ccff9df31e89922056b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end
