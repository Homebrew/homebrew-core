class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.04.07-16.34.10",
      revision: "bfdd8c1e902cd252db8f845fcffa92eb05261a08"
  version "20210407T163410"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "57afdf07a28d7d10d0a1150aa3184935576a701f594f0b5d8c0b70e293f13780"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c0efe6194f6eb24580e349dc5c6cc2d2676fbfaadbf2eb1f8cac65bacec34f8"
    sha256 cellar: :any_skip_relocation, catalina:      "d0ae3fd41947eaa583aca71ab6645154d2c78cd5e276ef70b2744ffe25795b4c"
    sha256 cellar: :any_skip_relocation, mojave:        "06a38f667df5c3bc5df6a67af072ae903298fc0a1458b0743379ac7d73298416"
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
