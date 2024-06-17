class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "f807a7378c78510fd7eba13607c3ec06c405ed08cc0605fade0fe2f7adeac101"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fea77785961cd6281f9aa1eaa1e6bf35e07ce6d654b07506200808548c8d53b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5cd91ca36832fbc45b2635de39e8364c644858b8725d11fc87d846d31dc42a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea7bb2ee5659e48393b88b4ea77f7b3b411375c6c674a4b668ef4532beb53bfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "935eab59a36de9bddf394a5d58781e9f0c944b59ea0e76ae9614f24f905884f8"
    sha256 cellar: :any_skip_relocation, ventura:        "df627296c3980b1dfe626e22a6effaa2e20a0ee73e5350ef9ba6fd54d4fbcd86"
    sha256 cellar: :any_skip_relocation, monterey:       "3202027c688d6b757a4ed49e35bb23840b3b754dece1e9be1cd5ca365307e76c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7417e8271d7e2a8ec8cb335030ed10389213d93709f94b7651d24ce66e9cc323"
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
