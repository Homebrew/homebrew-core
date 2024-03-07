class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "f807a7378c78510fd7eba13607c3ec06c405ed08cc0605fade0fe2f7adeac101"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43462d548c528749396fb097301a8a39463490ae673bdc1a6bb1c23560f63235"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5d0f9065d678adc766cc7740a0a45a468a18dc3cc27bafc073c069317688f17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8783057d106f56690ca2e37dbf796dc0dbc3d2fd944e9751e0e24ea778efef15"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6e317d9646b231f6157697ca542e9d2932b08f3069134c8e2ed3e371e8826de"
    sha256 cellar: :any_skip_relocation, ventura:        "1995c6f0a5df30b3befbe4a4a8ebaa490b8312f1d4259fa74ba0b5c64b322688"
    sha256 cellar: :any_skip_relocation, monterey:       "ab2910d21adabe4b1871a748b5281a0abe5e16f9f43f97c7763521f32c68b5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077ed2e51b3a16882e2cb3e210991ffe96b4ffa14fdac6c2c78e82561b4c216f"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath/"test.clj"
    test_file.write <<~EOS
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    EOS

    system bin/"joker", "--format", test_file
    output = shell_output("#{bin}/joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}/joker -v 2>&1")
  end
end
