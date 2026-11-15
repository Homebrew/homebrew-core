class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-10.tar.gz"
  sha256 "49ce783760429421645f6b4125dda374154148fdfbcb66fce61f772dbfaba851"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7881aeeed20800477c9730d037680e665262e94ff26f371f4e8098e64fcc50c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2a6de3dacee6a90fc432756280b5342243defd93aa93dac67ef6db98b337a13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f80f0da689ca207ce9cd4d88330617c15bd8980885db3fe7913dde03839d2f37"
    sha256 cellar: :any,                 arm64_linux:       "226526cd5023323d5e922f6c829b6c26570a2ba670fbc097a7df58edfe06e7d0"
    sha256 cellar: :any,                 x86_64_linux:      "52907b85383ea18f21bd5616bbfa3881b147317745fcaa3b3b752e039c377997"
  end

  depends_on "odin" => :build

  def install
    args = %W[
      -out:ols
      -collection:src=src
      -define:VERSION=#{version}
      -o:speed
      -no-bounds-check
    ]
    # Odin defaults to x86-64-v2, which is newer than Homebrew's oldest supported x86_64 CPU
    args << "-microarch:#{ENV.effective_arch}" if Hardware::CPU.intel?
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
