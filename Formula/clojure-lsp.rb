class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.06.01-16.19.44",
      revision: "d17d1347249477ee534e5df1030ff1b36c1e2ecb"
  version "20210601T161944"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7553eeef175e7fab98d3513a993162cf00a940575de89b1d6e802cc4a6fc5ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "edc2a4d6e3914895683c101f92e887b0d573feb9215972f0f178473b0f786b4c"
    sha256 cellar: :any_skip_relocation, catalina:      "166cbb7fbfe32ac69f9f77669df0ccef5f9fc4c161b7678e7c90c1d4585cc141"
    sha256 cellar: :any_skip_relocation, mojave:        "faa438a6e4f69f39e45c5b21686ed2d926cad60e0c3a0e380126b18675ee7517"
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
