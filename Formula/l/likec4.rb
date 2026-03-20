class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.52.0.tgz"
  sha256 "d2e77160f0b25e5bbe6790ccfc6e7e934204f74b04d87cfcec18e6248a419212"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30d9f0a691af014f5ac385a6d5e035137d0f34e2c355de4b823ea3d18822dc69"
    sha256 cellar: :any,                 arm64_sequoia: "f6d1d24770e87b882e7b1fd3e2a7f3d6ff9dffbc9f9fa23cf83f9586ca6522bb"
    sha256 cellar: :any,                 arm64_sonoma:  "f6d1d24770e87b882e7b1fd3e2a7f3d6ff9dffbc9f9fa23cf83f9586ca6522bb"
    sha256 cellar: :any,                 sonoma:        "4f772f616f597b27b16bde9fb2f492b8e40a11ba1038a60c786ea368f3fe638c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e79f7c0726ef046c7d7337fddb6b5b0ecfa304de675b28709ecf541521837467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c5ada91b8a3177d8184ed741701bb754d515fa248aac222ab26080c41b5a35d"
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
