class Kuto < Formula
  desc "Reverse JS bundler"
  homepage "https://github.com/samthor/kuto"
  url "https://registry.npmjs.org/kuto/-/kuto-0.3.6.tgz"
  sha256 "4e4ac78f04caebf634674fea2266d1701b20aa0a132513e58b25f8875d0b81e1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cad58c77f143c7fbfd10d10df241f2b4fd1bf9f66bb1d3aaa6dfcb22ff64af6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cad58c77f143c7fbfd10d10df241f2b4fd1bf9f66bb1d3aaa6dfcb22ff64af6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cad58c77f143c7fbfd10d10df241f2b4fd1bf9f66bb1d3aaa6dfcb22ff64af6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cad58c77f143c7fbfd10d10df241f2b4fd1bf9f66bb1d3aaa6dfcb22ff64af6"
    sha256 cellar: :any_skip_relocation, ventura:        "8cad58c77f143c7fbfd10d10df241f2b4fd1bf9f66bb1d3aaa6dfcb22ff64af6"
    sha256 cellar: :any_skip_relocation, monterey:       "8cad58c77f143c7fbfd10d10df241f2b4fd1bf9f66bb1d3aaa6dfcb22ff64af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f015ff49cc97418ef019b5830e80d66c7d545dea4f8d36b237825bef909bc61"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["TERM"] = "xterm"

    test_file = testpath/"bundled.js"
    test_file.write <<~EOS
      (function() {
          console.log("Hello, World!");
      })();
    EOS

    assert_match <<~EOS, shell_output("#{bin}/kuto split #{test_file} out")
      stats {
        source: { size: 54 },
        sizes: { './bundled.js': 53 },
        disused: [],
        lift: { fn: 0, class: 0, expr: 0, assignment: 0, _skip: 0 }
      }
    EOS

    assert_match <<~EOS, shell_output("#{bin}/kuto info #{test_file}")
      "./#{test_file}"

      Side-effects: Unknown

      Imports:

      Exports:

      Globals used at top-level:
      - console

      Globals used in callables:
    EOS
  end
end
