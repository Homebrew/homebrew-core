class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.03.30-20.42.34",
      revision: "9d29653980eb05a3c844773c5c92e4d7d01a6914"
  version "20210330T204234"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1564663152ba8a030873adddbe9548e36c8c22723b6d44e36543b3b3ea237cb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec24a79f4c29ca353df1615a7f042bf7ddcf4de33b3913ad041271c3bd9dd9bc"
    sha256 cellar: :any_skip_relocation, catalina:      "53abd2f5c98427585df1ebc603e37d333ba756329eace60cb76188e904eeeb43"
    sha256 cellar: :any_skip_relocation, mojave:        "d198687afba609f0369e09289521a64bea1d0ba38a4a9306ec0de072d758ccd3"
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
