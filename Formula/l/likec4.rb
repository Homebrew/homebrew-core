class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.55.1.tgz"
  sha256 "58e18ed18f26ff5b769b2117c440b0822409e0f9e6674fd34852f45fb6e2285c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4f6ce9b663d53ed9b707c423fa0fbea775ad4e993f23841638a9e9248ad982a"
    sha256 cellar: :any,                 arm64_sequoia: "c88db9551850ccabf02f19a4f3594b2c97ba1f64950436938281b872a8f8a145"
    sha256 cellar: :any,                 arm64_sonoma:  "c88db9551850ccabf02f19a4f3594b2c97ba1f64950436938281b872a8f8a145"
    sha256 cellar: :any,                 sonoma:        "2ca32a1b51f288dabccd66c557d3fd416ba22e5aada402dea2df5ca7c99508c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4f406c24860c0545f692919e80357b14077e59b3309afe0def11a45c116ace9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "294c3a883ce7529f4c19d70ffeea6b3c066160c1c843e1ec2392367601084442"
  end

  depends_on "pnpm" => :build
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
