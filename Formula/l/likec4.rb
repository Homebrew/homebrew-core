class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.60.0.tgz"
  sha256 "2a52f65809e68fa3f270a096c0eeccc5181f282bba2bf76931782ccd6498dd9f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "930a0c973ff3814e228c46395140efc934c0ebc6c1e135ab4673c629ecf736bd"
    sha256 cellar: :any,                 arm64_tahoe:       "930a0c973ff3814e228c46395140efc934c0ebc6c1e135ab4673c629ecf736bd"
    sha256 cellar: :any,                 arm64_sequoia:     "930a0c973ff3814e228c46395140efc934c0ebc6c1e135ab4673c629ecf736bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bbe7e6153cd99a4d2b68eb3865f4a3483295836eea9b3faef16121eb5ebf1a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3630a82615d2b631db7db3903ca5be6ffee27e3340e1f3916f615c845b57be6f"
  end

  depends_on "graphviz"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"likec4", "completion", shells: [:bash, :zsh])

    deuniversalize_machos if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/likec4 --version")

    (testpath/"test.c4").write <<~C4
      specification {
        element system
        element component
      }
      model {
        sys = system 'Test System' {
          api = component 'API'
          db = component 'Database'
        }
        api -> db 'queries'
      }
      views {
        view index {
          include *
        }
      }
    C4

    system bin/"likec4", "validate", testpath

    system bin/"likec4", "export", "json", "-o", testpath/"output.json", testpath
    json_output = JSON.parse((testpath/"output.json").read)
    assert json_output.key?("views"), "Expected JSON export to contain views"
    assert json_output.key?("elements"), "Expected JSON export to contain elements"

    system bin/"likec4", "gen", "mermaid", "-o", testpath/"output", testpath
    assert_path_exists testpath/"output"
    mermaid_files = Dir[testpath/"output/**/*.mmd"]
    assert mermaid_files.any?, "Expected at least one .mmd file to be generated"
  end
end
