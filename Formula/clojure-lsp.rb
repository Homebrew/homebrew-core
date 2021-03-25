class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.03.24-00.41.55",
      revision: "3cf38b47c953f7e21d535df4cb91a71a36f03d09"
  version "20210324T004155"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "714620021f25ee83e39040f14bd58b7a4d1f94ef57e5ce9de737539fb50964e1"
    sha256 cellar: :any_skip_relocation, big_sur:       "115564a76c5f8b45e487c0648bbac13a77973137d1ac7fbcdd673c18033c9c25"
    sha256 cellar: :any_skip_relocation, catalina:      "352d8a0f6581fc9e56e7ec103f716f966995eeb2d0d9a2065bf4b4fcb9630160"
    sha256 cellar: :any_skip_relocation, mojave:        "d1e46a6739dbc18dd5366855a5de4a2bf55957f453bbc70b5a38b768c845c833"
  end
  
  disable! date: "2021-03-25", because: "does not provide the native binary, which is the recommended way of using clojure-lsp now. Please see https://clojure-lsp.github.io/clojure-lsp/installation/#macos."


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
