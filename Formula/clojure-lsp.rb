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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41c3d632d4f0023ed7bc73163103f0c05a0c6cbb820ec984883620e54974c796"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5ae5b9ebe5228e6de7c5e7aa377e1b5c15ae0bcde9577cd7a6f439f5ea4893a"
    sha256 cellar: :any_skip_relocation, catalina:      "af6e0975d10f208689a4b8c516eb9621304438db534c6d1dd3db9679260e31a4"
    sha256 cellar: :any_skip_relocation, mojave:        "7ffd44c23974551b48ad2996b366d7aac01f092ceffeb154e6fc8fea2144c838"
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
