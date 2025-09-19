class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "09e45a6f5dfc86819c31b8c157068b0e76bd52036c881210d6645973bbbdf55b"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67af43f8a4277a88210ee6cd9758fc71f76e55ed3497d6253e666116527091da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "679b9eae3720dc9778350d62f3817a0911eb5b221dbaa565324b5319a29da46a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "679b9eae3720dc9778350d62f3817a0911eb5b221dbaa565324b5319a29da46a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "679b9eae3720dc9778350d62f3817a0911eb5b221dbaa565324b5319a29da46a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd5cbe3c6e92f785c502c6ad3a91ad89a296bdc5b0cd657143b98c914df41d34"
    sha256 cellar: :any_skip_relocation, ventura:       "cd5cbe3c6e92f785c502c6ad3a91ad89a296bdc5b0cd657143b98c914df41d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ae5d2126bca255142c39421208a11fb6543a7e2e02cf89430d2bc92fa6d20be"
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
