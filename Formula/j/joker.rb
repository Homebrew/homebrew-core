class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "5e2f5bc5d03ae456cf032d73f7fed0b4475e23b5a05b65abb97256362ebeb7c8"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc7d74a8ab4c36f93af4117c52f075869041167063eb3932d2de6470c9e70e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc7d74a8ab4c36f93af4117c52f075869041167063eb3932d2de6470c9e70e55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc7d74a8ab4c36f93af4117c52f075869041167063eb3932d2de6470c9e70e55"
    sha256 cellar: :any_skip_relocation, sonoma:        "25ef9cc98dbd047f14b62f12765cb42c2f80169a0ad73758a879be62633bc796"
    sha256 cellar: :any_skip_relocation, ventura:       "25ef9cc98dbd047f14b62f12765cb42c2f80169a0ad73758a879be62633bc796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "814f07a5f49b86edf2ad338cdc27a7ae289fc3a1c4270266de172fadb4d1167c"
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
