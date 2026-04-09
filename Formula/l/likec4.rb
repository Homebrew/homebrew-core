class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.54.0.tgz"
  sha256 "d2213d3630c84125e0954d2cad4adda9143fc686592840fc665914511b56be9d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "535a672629e918a452cf21af4410131c73c45d8f94bb84a64c6514df6f6f40d1"
    sha256 cellar: :any,                 arm64_sequoia: "ee810c8f6a47ff06511b97bc58fec8817daf3aff23c9a2009272297c21d4c505"
    sha256 cellar: :any,                 arm64_sonoma:  "ee810c8f6a47ff06511b97bc58fec8817daf3aff23c9a2009272297c21d4c505"
    sha256 cellar: :any,                 sonoma:        "da9307c1fc040c5830a4f6a607ad83cbcb019588d295bfd845742fd4f1a44f10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89c4196f604778c56d7202df00fadc53e7a5651fbe5b30661669959398b7c69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4688ce2777a170aedd7381c0baaaef5c93b00a3a4acfd84c1e46833acd393707"
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
