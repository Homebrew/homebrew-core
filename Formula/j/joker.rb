class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "4584505068bb63601bae8e1eef555e08a7ed01117d25fae2e87a1a101c439b99"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1805aad8f4f7b6ab15f5c10de7101a9e1649e6d962f3fbcdabda182d0c207a47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1805aad8f4f7b6ab15f5c10de7101a9e1649e6d962f3fbcdabda182d0c207a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1805aad8f4f7b6ab15f5c10de7101a9e1649e6d962f3fbcdabda182d0c207a47"
    sha256 cellar: :any_skip_relocation, sonoma:        "74a8c7af4675c0407f6300ef51d585aca9be02e804bf7c45b5fd493a1de94753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f99d039123ed57a7f1503d6dbf363a2f3bf67f500f810c64f402ab3f036a32e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d2af5806fb3aea5cf33cb60251d76cb83248f1cdf56b692fb963c51b2a0971"
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
