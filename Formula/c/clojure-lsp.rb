class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp/releases/download/2023.10.30-16.25.41/clojure-lsp-standalone.jar"
  version "20231030T162541"
  sha256 "4e2fadf51e6b1e64b7b532d6650726f49f438e92f714b34e206268d6503c3370"
  license "MIT"
  head "https://github.com/clojure-lsp/clojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:release[._-])?v?(\d+(?:[T/.-]\d+)+)$}i)
    strategy :git do |tags, regex|
      # Convert tags like `2021.03.01-19.18.54` to `20210301T191854` format
      tags.map { |tag| tag[regex, 1]&.delete(".")&.gsub(%r{[/-]}, "T") }.compact
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50d783342293e1bb38afae569dcc36e046cba83c1df28bf10eab924db5724d3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50d783342293e1bb38afae569dcc36e046cba83c1df28bf10eab924db5724d3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50d783342293e1bb38afae569dcc36e046cba83c1df28bf10eab924db5724d3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "50d783342293e1bb38afae569dcc36e046cba83c1df28bf10eab924db5724d3c"
    sha256 cellar: :any_skip_relocation, ventura:        "50d783342293e1bb38afae569dcc36e046cba83c1df28bf10eab924db5724d3c"
    sha256 cellar: :any_skip_relocation, monterey:       "50d783342293e1bb38afae569dcc36e046cba83c1df28bf10eab924db5724d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "340c1cd021cf2f7bb8405d46b42d58a9383db3e121060cf792a353ade9c8f3d2"
  end

  depends_on "openjdk"

  def install
    libexec.install "clojure-lsp-standalone.jar"
    bin.write_jar_script libexec/"clojure-lsp-standalone.jar", "clojure-lsp"
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3("#{bin}/clojure-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
