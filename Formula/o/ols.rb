class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-08.tar.gz"
  sha256 "e8d368f35b6833efa7e840753881d01f76607f3c0872c614e536f2b7e939f800"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8c2c77dfc19c898fcacf0ce6e4281e17feb25ee43399e126b2922434eabcde1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1bd6653534dc50b6e15eabdf6fe16242ad4cce655c7c7a2fa363d1cf146267ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a5df06f67d0d20f5f0a472f50abe8a6e8384ddd67fae6cea47a9df78afc1c15"
    sha256 cellar: :any,                 arm64_linux:       "3b2ea7d4c75442ad560218248b1bf718e69366208e187831f83e0e3c4b2ef048"
    sha256 cellar: :any,                 x86_64_linux:      "12348430da10574489ec6e59cd3a9a44eced5aa67b1297f61434581d802022ad"
  end

  depends_on "odin" => :build

  # Backport build fix for odin 2026-09, which replaced `ast.Inline_Asm_Expr` with `ast.Asm_Template`
  patch do
    url "https://github.com/DanielGavin/ols/commit/5f1b4d773b05d98dc9533521490096cf1a06a6d3.patch?full_index=1"
    sha256 "e76914e29a26bca835d115111c1017ec0e6f7d51edc93a8c0e1f9a1fbd7c6368"
    type :backport
    resolves "https://github.com/DanielGavin/ols/pull/1653"
  end

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
