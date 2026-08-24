class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "cdb2878f1a6b46fe0ed54dc4296dfae0e4ac9a3fa1b7e842e12b8b5b703f3949"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c99d37ce578ea253b9443d0688bed37f88d5155ce45570f1f91721f91ae4912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c99d37ce578ea253b9443d0688bed37f88d5155ce45570f1f91721f91ae4912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c99d37ce578ea253b9443d0688bed37f88d5155ce45570f1f91721f91ae4912"
    sha256 cellar: :any_skip_relocation, sonoma:        "f08dca004b651c5f21e70d45bd3fb0c1f913e4c59c8a08fc9d03ea19371a19fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed6ce659e7a7ff62696091e5a14c69098f6f66a8388b234f5a5ef7ac8d2b4a48"
    sha256 cellar: :any,                 x86_64_linux:  "dc34af606bd49b22b3d15266c94fd26ddcf8bf11fc1491bf849420b54d00c253"
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
