class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.03.06-17.05.35",
      revision: "fe2e44152b8d680e560e3c7a854621404f6ee2c8"
  version "20210306T170535"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "217dbb83eb2ed497f23587a386a81c13c18cb2f1fe1f7e8c7497a0ec2fc6ad41"
    sha256 cellar: :any_skip_relocation, big_sur:       "21fef943dd5730b001ac304dd8ea556527dcfd5214c2d92180c8ee7fa53f65d7"
    sha256 cellar: :any_skip_relocation, catalina:      "607f844d979cb06a73fd36adefa215bb6144ed7849fa21c201a7cb81aaeaeb45"
    sha256 cellar: :any_skip_relocation, mojave:        "45f6603e80b995a0ea41fd33276a98aff8295cbd4aa7f3ea6a641618e6780de7"
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
