class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.24.0.tar.gz"
  sha256 "ad565f4c49f7fb29219bd833860d53ec8b7ce6bc37ad4c6702e05636d2bbace2"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95c6e5f3f6f80021cb0d0b770e10501ab6019de78956a65f49bc813e6d1367fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef7c581a06ec66ab1684a4ccc5c53525f1ef3204426bc027ed4c9274b097eaf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b53c46794a0e2808cdcc125c842e57a8122f53a89000fe9d96e4d9fdb07ef7e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1591139b6f668b2e86c77b0f402b299ed08baa80576df217d7f91710b02e8253"
    sha256 cellar: :any,                 arm64_linux:   "de591a557de25e72bd0eee0a91f6a2f8f91f4f4d15f2b29e775fb626fe9bda1c"
    sha256 cellar: :any,                 x86_64_linux:  "046ce795c04e7dec587bd60c8b4ebaa0ffae78823d6c7f71461425ca139b53a2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_ls")
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_doc_cli")
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emmylua_ls --version")

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

    Open3.popen3(bin/"emmylua_ls") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
