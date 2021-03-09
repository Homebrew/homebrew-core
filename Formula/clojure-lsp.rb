class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.03.01-19.18.54",
      revision: "3c2dde99451a545da61d6a30ca3e7071581a1aa9"
  version "20210301T191854"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d390d657349ecad4b0a0c56fabf6a4ce322ed49df08b100b8543e3578425723"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc21005dde338ac2c543c60fc0fe91fd26eaea952cd50e5c440569e879905ef4"
    sha256 cellar: :any_skip_relocation, catalina:      "b9a7dc46c9e19171e96bee191c38a3b6c2b36fcba85862d0a8e5043bb0075e5c"
    sha256 cellar: :any_skip_relocation, mojave:        "79236bf7ddf83da7c5cc667978526941879d45bb906595d5ff1000696bb528eb"
  end

  depends_on "leiningen" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on "openjdk@11"

  def install
    system "lein", "uberjar"
    jar = Dir["target/clojure-lsp-*-standalone.jar"][0]
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "clojure-lsp", java_version: "11"
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
