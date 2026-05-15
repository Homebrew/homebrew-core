class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-05.tar.gz"
  sha256 "387b9f47304abab5c7cbe12f041c85de892ddc94a54e03f2789ff6ac9fc16386"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b86200160fe6bbe50d438f0f49eef4aa8de99cce1ceff70e571c4af45ca058e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf3c09acefeab047e1fe8c66fde82060be216dae4c3be42827609e8a380cd61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b2abcae76c0e31ff66f3325c55b643ca43326053ad50937a366350eed81e9ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7eade8583b1949046fe500c0ff0ab8fe1c6f79941a26fbe83c466398abaf6bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8afd8529388e1d5cc1020da1680c46ae51b5b315f6ce944caf0e3f90993607fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46cea1e0dd6a69174dd7edde69b09c4d6c98df7efd2d0f057a792e330866c27b"
  end

  depends_on "odin" => :build

  def install
    args = %W[
      -out:ols
      -collection:src=src
      -define:VERSION=#{version}
      -microarch:native
      -o:speed
      -no-bounds-check
    ]
    system "odin", "build", "src/", *args

    libexec.install "ols"
    pkgshare.install "builtin"
    (bin/"ols").write_env_script libexec/"ols", OLS_BUILTIN_FOLDER: pkgshare/"builtin"
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

    output = IO.popen(bin/"ols", "w+") do |pipe|
      pipe.write(input)
      pipe.close_write
      sleep 1
      result = pipe.read_nonblock(65536)
      Process.kill("TERM", pipe.pid)
      result
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
