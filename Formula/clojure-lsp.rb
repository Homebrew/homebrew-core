class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.04.27-20.17.45",
      revision: "f4c07bf0d6db23cee7e89e87fccdf2e5ec049a15"
  version "20210427T201745"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1719036a888d52fa386d7ea32f573ffc043a6cf707b49881a5ffb9649a58fab7"
    sha256 cellar: :any_skip_relocation, big_sur:       "970d2e9d03e51e3ea1a99d11405ea211af5181ebd28eb7a2a7cb51ea1c27c35e"
    sha256 cellar: :any_skip_relocation, catalina:      "95ec5014d85d5f09e97c6193fd6aeff1ea7c29141277a1c553005582e86e3af7"
    sha256 cellar: :any_skip_relocation, mojave:        "0fbb4c3ee8f634ff495637461bfc30128322a3004022c2f5432b5c507925fe69"
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
