class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.08.16-19.02.30",
      revision: "226fa911d10d332a2b1df9201cc8565a3002f642"
  version "20210816T190230"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "659173e001c1786eb50a9c8beef74c0ba6280c2b1ac76595e123aad636a3e3b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "202351955dff5b6e65ebb1748c81514cd0dd3d3e9eb9d20a1d85733f6b841c41"
    sha256 cellar: :any_skip_relocation, catalina:      "199800115e7f86fe0a9bfd5f623603cb929de928fc387d227ab72166af7ac042"
    sha256 cellar: :any_skip_relocation, mojave:        "d833ec0f89a391ad22b56a4bae511b22e94fefe23733bac2150d4bc3f284d237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8f150b92e9adc756bfa28bc955f719d7c429256543eaeed02eda13d5a793daf"
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
