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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8579a9da60c930b2380abc974191320ce9b54d5bf799baa02c5f05d1582911f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "28c5958f76f62b437a5b19da61edda486301623ddffd4624a35d3746e7f4c2b6"
    sha256 cellar: :any_skip_relocation, catalina:      "3be0166f8f95c284995ad1643a63d6769ec6a005867f468e6ef7ceb48b892f27"
    sha256 cellar: :any_skip_relocation, mojave:        "f76ba5e6fc5dd5666813a736bafa74995c1e4fc0b6f0349257d813576d6393a9"
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
