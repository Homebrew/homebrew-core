class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.05.06-19.44.00",
      revision: "081137d6ab31768be18b04267a415ccca153a5e1"
  version "20210506T194400"
  license "MIT"
  head "https://github.com/clojure-lsp/clojure-lsp.git"

  livecheck do
    url :stable
    regex(%r{^(?:release[._-])?v?(\d+(?:[T/.-]\d+)+)$}i)
    strategy :git do |tags, regex|
      # Convert tags like `2021.03.01-19.18.54` to `20210301T191854` format
      tags.map { |tag| tag[regex, 1]&.gsub(".", "")&.gsub(%r{[/-]}, "T") }.compact
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66b7a4aa04c1e7a74d970f4a408bc8b82146ecc596cb90e9c59c236ecc8546ac"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc7b1dd38b1d12f2bf091ecfeb271be713807b4a7bc40426f7777a20a7b61506"
    sha256 cellar: :any_skip_relocation, catalina:      "1c6eec1ae7286dc6ce00af6b5dcfd4253f48c7296bd69f3f74c88e5820bacc0d"
    sha256 cellar: :any_skip_relocation, mojave:        "0fa06f932cdd0e7dd343d3e0c6f1abdd678e4c87f2b7bebffa5340f49430b11a"
  end

  depends_on "clojure" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on "openjdk@11"

  def install
    system "clojure", "-X:prod-jar"
    jar = "clojure-lsp.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "clojure-lsp", java_version: "11"
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/clojure-lsp", input, 0)
    assert_match "Content-Length", output
  end
end
