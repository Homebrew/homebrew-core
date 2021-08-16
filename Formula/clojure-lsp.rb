class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.08.05-19.36.09",
      revision: "f96816770597981f8afdbc744bf9782caca38417"
  version "20210805T193609"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41cb4117527c13f5b926eba5d939d16788192f27523637a55ea6e33a47713375"
    sha256 cellar: :any_skip_relocation, big_sur:       "118b882af0ed934b2d1bc23b16491a9f0360a6332f7ccc2919b91bbe1b55e85c"
    sha256 cellar: :any_skip_relocation, catalina:      "42d3763aea4997339627fe393f4479623cc90e5bbe65f34d3e938fa0dc12a2a3"
    sha256 cellar: :any_skip_relocation, mojave:        "499b652b0b3e2c849be7498653b6df7a44ef620edef5a8ae54f4d899c98b900c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48e86995dfed189aed5e539ad1152a2f67504359c3ef3040ebf80054bb7203e7"
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
