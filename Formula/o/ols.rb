class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-06.tar.gz"
  sha256 "f8055ff723994dc4debc02817c230d0173c43a23df4a9d6a7104fea69bfeeb79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a49baea6971a77139c64f502528c92a03cad8e372752698adfcac62a71ac6e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7df0ff6be994f67f0d71f3a3d94dbda07f7abfbb7f52e5e4d2108e1e3f4c292c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e52573666caed3630c0d028498e48b69341990b85eae91c2ed99ba7eb0c6a64"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d9609fb41f362866430a73e9471d73c476d38b04b2f62b1d5f724382e983cd"
    sha256 cellar: :any,                 arm64_linux:   "d56a278faf220adeb6c3a0c246bcbc746c9d7c006da2094ca8eb3f2ac5a56f2b"
    sha256 cellar: :any,                 x86_64_linux:  "41ac14ccad569877bc735c1e6dc9de3dc6f52cff7cf9cf85b408532cecbd809b"
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
