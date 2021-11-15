class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.09.13-22.25.35",
      revision: "d564f81e25c71cc370c33d745881af1187f97667"
  version "20210913T222535"
  license "MIT"
  head "https://github.com/clojure-lsp/clojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:release[._-])?v?(\d+(?:[T/.-]\d+)+)$}i)
    strategy :git do |tags, regex|
      # Convert tags like `2021.03.01-19.18.54` to `20210301T191854` format
      tags.map { |tag| tag[regex, 1]&.gsub(".", "")&.gsub(%r{[/-]}, "T") }.compact
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90574ce478618d645bfcbb07b46247f75b94a581eb231dd4c1b84f49d96be60c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba891cc1306683265d67cac7c91cd99bba90bc3e79db6174cca325c952b6f07d"
    sha256 cellar: :any_skip_relocation, catalina:      "94a41008e212ff412f36227d2f439a2a6636b16b3a4331e1c5e93a2fb601936f"
    sha256 cellar: :any_skip_relocation, mojave:        "26545581a5a5fc5ea13bb252ee4c76eb10284b25f9102335e93e7971548d05a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b8f92dadb82afd0bee547349f330a415c9fd1d8ab8ed80c58495b02c6f140e0"
  end

  depends_on "clojure" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on "openjdk@11"

  def install
    system "make", "prod-bin"
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
