class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "94fced43603f382309944544c527e27042523feb2c253e5cd1661d91c656bd36"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "367f7b70bb431a644e0e9b8749c70d1059539ad449f4091d2fe260d0cf766ea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "367f7b70bb431a644e0e9b8749c70d1059539ad449f4091d2fe260d0cf766ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "367f7b70bb431a644e0e9b8749c70d1059539ad449f4091d2fe260d0cf766ea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab3c407e8a3aa72ce287884e9c9a8026224d615f772f3f4a37060edbb86cbbe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d150d2620954eab2bc730b43c7eb4a16fe648c8a3c4c8c986828a9a625ba895"
    sha256 cellar: :any,                 x86_64_linux:  "5beb0a9af346db8bfe0453c3d12d5ca23f8c85a7942ff17c60b7ffb0d7b1f804"
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
