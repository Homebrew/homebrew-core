class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b05a9f15553f748b9ef827e6c96b42ad9c9d0d6bdf76ae592e77fae640b9d198"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a50e67e9187a3e04d3a4663857df868bcd31389ab49094c09875f772da34f68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89681b46dab383e92abf204c4977f3e526c5b160e37fb5e7d66df85c9a4d9187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6105453965b056722ab39eee591105c4626c3e5875121c515fcb25245c434a77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6a3bd6e773bc2023b970cf61daf312eb8987ec3b4bad0920274a0a9e13e5146"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa87be327d22e1414d23a59a4203efe60404edd17e066e467797fcf3a66b0bfa"
    sha256 cellar: :any_skip_relocation, ventura:        "d095c283b61c62a0df3ea337f8415c74fad1f2e5d2d5764d00cce5c7a0884e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9a5b1193bab0b5248dc552ed29ec02a2ec65f1e619211e08fc7665ff43c28b"
    sha256 cellar: :any_skip_relocation, big_sur:        "39bfde9a15159b20717c0af76849726c7879e1b26075ce7b53cdaa06a9ab76ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e28429584a8a7be16f1d5a0cdc6e0acedf761744767c86d2a859bb6bf6b3da9"
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
