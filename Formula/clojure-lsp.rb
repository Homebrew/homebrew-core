class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.04.03-18.43.55",
      revision: "e0abdceb0e500d37c6236787e7b61479f64a0e16"
  version "20210403T184355"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5b2ea84a5789d34bff10b4c2f5e27df53b2d704ace1cba26be05eaeed0e5700"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7bf4557188eb60f65534d703ad200efa42ddc7a96090422fd348431b4490501"
    sha256 cellar: :any_skip_relocation, catalina:      "368cd1787263d4a1a2803a0951ea342bc6444bb58485b5d2a681d174980b2d25"
    sha256 cellar: :any_skip_relocation, mojave:        "0dc28329876c96489962a7c5235b505c4bb281cb7eae91088548c8b9bbb48b89"
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
