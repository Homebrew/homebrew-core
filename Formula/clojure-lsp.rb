class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.05.14-15.26.02",
      revision: "e5a377df84504adaeaa68a3a3a61bb637eb63fba"
  version "20210514T152602"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "541859319d07784bcedb7dd97036940d532d0f12a3bd39f03d9cafbe9f8f9ba7"
    sha256 cellar: :any_skip_relocation, big_sur:       "02a65c4e350f5fd0745ed640f4645f52e89c7c9239d875e2910c0a6b2a127b89"
    sha256 cellar: :any_skip_relocation, catalina:      "3f4041f6a74994313d2d09c5515155986dfd3af59150b0e28571865c96db5924"
    sha256 cellar: :any_skip_relocation, mojave:        "e3a860d107d18f37a051330c90601a53b6ff3c9cfc9872fa7523d2872e08becb"
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
