class Kuto < Formula
  desc "Reverse JS bundler"
  homepage "https://github.com/samthor/kuto"
  url "https://registry.npmjs.org/kuto/-/kuto-0.3.6.tgz"
  sha256 "4e4ac78f04caebf634674fea2266d1701b20aa0a132513e58b25f8875d0b81e1"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "d0b642c13ec7b23fd229ef06d6ab335cb2cb3eaea4785644006ab84572b0d8bf"
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
