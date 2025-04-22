class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "041535d734db2927aa8c32794c012fd1636d2a5aec15aaf2e7b2f33fc8973808"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69cf78e5e0c26b880056f48624622827ee4c2204a9233d24726a66bdacd1d1a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69cf78e5e0c26b880056f48624622827ee4c2204a9233d24726a66bdacd1d1a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69cf78e5e0c26b880056f48624622827ee4c2204a9233d24726a66bdacd1d1a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "81f87cda13426f96a91bc65de5a0b4e4adec4bcd742d7aae4c5e2f742197eeea"
    sha256 cellar: :any_skip_relocation, ventura:       "81f87cda13426f96a91bc65de5a0b4e4adec4bcd742d7aae4c5e2f742197eeea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad596d08da5809cb57325e07aeff635d96f459ea686310c26157251888a5677"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath/"test.clj"
    test_file.write <<~CLOJURE
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    CLOJURE

    system bin/"joker", "--format", test_file
    output = shell_output("#{bin}/joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}/joker -v 2>&1")
  end
end
