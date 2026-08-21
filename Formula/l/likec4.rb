class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.59.2.tgz"
  sha256 "223eca51c07a4368c5ecc43c1f7d127b1a9f783c7ed248d56add1f8aa0cba0f4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0360ad20b0b80aa81fd732b2cbfb95fe3a1b1615754312bf9b21441f8d2e3ac9"
    sha256 cellar: :any,                 arm64_sequoia: "0360ad20b0b80aa81fd732b2cbfb95fe3a1b1615754312bf9b21441f8d2e3ac9"
    sha256 cellar: :any,                 arm64_sonoma:  "0360ad20b0b80aa81fd732b2cbfb95fe3a1b1615754312bf9b21441f8d2e3ac9"
    sha256 cellar: :any,                 sonoma:        "6c265ab8b3e938ff52350956f93b07bef8e00ae76496dd35ae613fd3712cc0e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01ed4d0b024b1d83156f3a09190fb8ce1ec382608a0e5a8ce9c72e92cac975c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7826df04e025030b82bef3ffbfd6a999875b475c4fb34cb50d9cab049ed3ec"
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
