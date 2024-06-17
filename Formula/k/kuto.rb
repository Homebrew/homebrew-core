require "language/node"

class Kuto < Formula
  desc "Reverse JS bundler"
  homepage "https://github.com/samthor/kuto"
  url "https://registry.npmjs.org/kuto/-/kuto-0.3.6.tgz"
  sha256 "4e4ac78f04caebf634674fea2266d1701b20aa0a132513e58b25f8875d0b81e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef0cca54501f33ac8ec2b3610a5d0897035e0ba672301e5bd7a6f858d4eff110"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
