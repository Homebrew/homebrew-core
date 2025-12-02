class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.23.0.tar.gz"
  sha256 "19c85e175f3b8cd7a7ba30ce6270de766f995463dd296a5a98b04fd43bbc1279"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2eca67dafbfc92a86203b5900704b547f9fe9b2a5bb79313e2bfde170d51b787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ea32f28e464938d7dd4d9046ac3930b9f988b1d357afe0a1fb6b6cbcd6f89dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e3936974459aa7b60c72843dd0131ecd5d9c35aa7d824a1ff966b2dc9bc0ef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade93b0174b9931c4071dcf9b893c3d9ff441b110e01574b2ac88220e0978436"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea3ff0cec231a12ad7b73c1d1228fef747afbc37036a1df75559da94ac5a9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037eff3fbcdaa390493cb9bea89c0a4ff807b06bfcf04e7a874277793d003988"
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
