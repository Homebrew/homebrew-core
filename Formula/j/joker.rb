class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "515c2219336b9b480413a4a8e306c3f2d1d0dc9c84183b0c0446a5f717e783ef"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5e018c261e26c80bb5ff82e8fde6f2f45672624ced6931a931ac156ec5ad5b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5e018c261e26c80bb5ff82e8fde6f2f45672624ced6931a931ac156ec5ad5b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5e018c261e26c80bb5ff82e8fde6f2f45672624ced6931a931ac156ec5ad5b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "709f693f02b01a63e9a178caaffe334979ffbf3133f67c47e474bb8904acdf86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f5c33a6dfb030154fa8657549e6f30e36cb88f1a77204656567fc2d54108ca"
    sha256 cellar: :any,                 x86_64_linux:  "856ee2e6555d33045b8db2661915e13847e30865df85bfecde220c525be00cc5"
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
