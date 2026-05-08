class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "5946755e194e44dbf4b79e35d47b4f17be03804fe6a9633f1c0a279f22183c16"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70163d906fe29b259b2d45acd5d2aa4fe9c917b27f6dcaf94d3f246835f3960e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70163d906fe29b259b2d45acd5d2aa4fe9c917b27f6dcaf94d3f246835f3960e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70163d906fe29b259b2d45acd5d2aa4fe9c917b27f6dcaf94d3f246835f3960e"
    sha256 cellar: :any_skip_relocation, sonoma:        "428acc9bb9b254aa39a368b96ea8d92da21d18f9340a0ddd5f40b417f6c5b7ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48198971bd9d127d694a355f982b0d6c7b69af735ce1409ff1c7bacd187a72ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc6774ce952aafbaee43a147f8099842291b584c8b59cb0f9fd324810aae3de"
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
