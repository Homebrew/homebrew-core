class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "40f2f4989107c3ee070f18b55ce7c51ef6adceba44d8519b77bff478861ebda3"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eab230588b23d3d38e8f0cddecd4ad09daf92b05a5848801abdbbc19000cec49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab230588b23d3d38e8f0cddecd4ad09daf92b05a5848801abdbbc19000cec49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab230588b23d3d38e8f0cddecd4ad09daf92b05a5848801abdbbc19000cec49"
    sha256 cellar: :any_skip_relocation, sonoma:        "869f3c38be36ef402375bfeae3cb2b5d5c08c22ea3159f85875b5cdf567985f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a13a67d57b7cf00c1c19ced16030ee26057907692faf0ddc4135168b2e9df6a"
    sha256 cellar: :any,                 x86_64_linux:  "1f897152e3519b6071ee7c1129bbd1bf1486d871c28ca6e055ae66661c10536c"
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
