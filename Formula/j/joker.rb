class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "e924fe89d6cde89c8c50937ac898487d70977ef059d5fc6f3a3b57b1fca915b8"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b702bf468726dd2869228e1e5d4b8d3d4e4efc310a0cd7e2398cb6d49b9dac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77b702bf468726dd2869228e1e5d4b8d3d4e4efc310a0cd7e2398cb6d49b9dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b702bf468726dd2869228e1e5d4b8d3d4e4efc310a0cd7e2398cb6d49b9dac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6da4903af75f85c98c66bd516d4467611f731c9def24216faae35b5d6e42884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d95314314788ac45d48831b5ecb874fb4bba7e9c86d481969527968f79ac4c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7c8044ace9cd93300dfe4800bf2a66b122e65910c2d20710a68d2a0c548f4a"
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
