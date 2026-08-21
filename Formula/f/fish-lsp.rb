class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.1.4.tgz"
  sha256 "d42edf4cb15f09b1e6bd96ddbf9a4954c11b24b504d1118d84bef4df414efa90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcbef4048454b6950e049149de392a7fe255299b02f42a6d9836597ad7be4907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f470b1874386527238b5ed0748d5f7adb1bbb1f32d0e71d355f930bc1c09b749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d200592220693ec2fcbfa5fc0e824fe950ac4c62d4a8d4ce6702e8e0fa414fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc8c154948af7b3465829bf3615dba777c1b36efb13d9d36b8c8e7e4d503e8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec93370a9d330ad22a741a82541967ec5dbe792d7849d7629b5baf1330be4c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e9b96d6996eda61eadab4a30c14cc1f8fd9901a5d3565cba8ee9592f575afbd"
  end

  depends_on "fish" => [:build, :test]
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    man1.install "man/fish-lsp.1"
    generate_completions_from_executable(bin/"fish-lsp", "complete", shells: [:fish])
  end

  test do
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/fish-lsp start", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
