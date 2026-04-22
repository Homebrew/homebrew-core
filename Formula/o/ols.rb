class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-04.tar.gz"
  sha256 "887dbcdb5418a16b52655bc0953bddf798919520123d5a3eb5d27a9125800d8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40a9b092f327c75244d8c6dff40e2bdd82b30b87169cc523061cd68a1f562634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "446ccf2b0d9b7c09e5e1a37fc170428e1d82881ae9375f6d87b849a9ca57afad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "752fb0db34aac5dc444a830595258fb5d1e34f107e330d9710b0846d711e2e94"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf469719426a1d3fd52f4e919270396f6c4755d3a0c2b53c5a5d675a01a27c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57d4c981e0f1416a5e3ea8d63f6d695a9c8e337d55e8060895cd157be6833dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed75becb09a6d303cfca605b0cb6d08789f801566c0983aa8bdd0b01ccca98e"
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
