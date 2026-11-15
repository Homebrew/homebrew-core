class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.61.0.tgz"
  sha256 "892ea1363fa213f7425215bff61e59dbc4f336d0f855eef26a184e2697ed5853"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6e62f09bf7669ed6f901c5a9b1397ed094dbc5447bfc49c1b7a9aa1783fd0a1b"
    sha256 cellar: :any,                 arm64_tahoe:       "6e62f09bf7669ed6f901c5a9b1397ed094dbc5447bfc49c1b7a9aa1783fd0a1b"
    sha256 cellar: :any,                 arm64_sequoia:     "6e62f09bf7669ed6f901c5a9b1397ed094dbc5447bfc49c1b7a9aa1783fd0a1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6cb79f79ec3d02ecd23f9ebae062682d60152e101d629e364905ac0e07f61d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "43798fbae80afcffb6f523b0d6d31b695736836eb56a102860e52888bd52e68f"
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
