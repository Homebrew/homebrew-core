class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.58.0.tgz"
  sha256 "07c9311acff0af52a3ee5d708901bf588b7812c009636e188ff5bd57988bcbad"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21273207880bc971ed9c5cc0ea62595ac7ec4df2fb89d8a4eefc70d2cffccfdb"
    sha256 cellar: :any,                 arm64_sequoia: "d89aa7857494ec970cf8fab38413cd65a1c4baa81a07171aae8e585f4f573b25"
    sha256 cellar: :any,                 arm64_sonoma:  "d89aa7857494ec970cf8fab38413cd65a1c4baa81a07171aae8e585f4f573b25"
    sha256 cellar: :any,                 sonoma:        "a37f5aeabb5af012dd4f73e1b9f06c3a67e80e51c4d7b0f102f1b753aad917d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61e487f1405ec2b73700a190ee1d403d80dd977ac58df7064bd349c2afe0e303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cce7b74d3c8bff1837f3556c6af07ce49fed46a2fc2a5bd735738bc48df037f3"
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
