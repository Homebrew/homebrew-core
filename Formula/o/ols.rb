class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-11.tar.gz"
  sha256 "9cbcb116d666075c51cf7c005faf7392a398c75e8adbea476d6a01f779793565"
  license "MIT"

  bottle do
    manifest_sha256 "a78a8f124764dab507bdb418b1ff01d87fa7d95efd41fd0fbeccffee39ad6f03"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "453c23fbc22e8db6a05f9f8d0605e4ed4ec6dc00d378ae64afd2b8cae3eb2597"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7be33296a793f909cbf06018980d551a4fbbc03f07e37770d227794a575ac860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db0bcc72d883e938c9b201eb4b1ba35158645b3f4916b3cca5b5fb71eb88ca19"
    sha256 cellar: :any,                 arm64_linux:       "41b6f7cadfcc59252455ec8b5c0790711b014dc351fd41f4de47204b7aae5d02"
    sha256 cellar: :any,                 x86_64_linux:      "c2946d8dbdf350a6b0ea864d8a862405d39b59393a84f6d8e1da3ee04e71a9e5"
  end

  depends_on "odin" => :build

  def install
    args = %W[
      -out:ols
      -collection:src=src
      -define:VERSION=dev-#{version}
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
