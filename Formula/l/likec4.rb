class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.56.0.tgz"
  sha256 "736bdda816cef207536869f98c33e01f4a3f9aa484e7717934234b8c9dbf74ff"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "341ad8cdc29fef0f4fde826ebdca17b779d16f3ce95139b9c647ffcc9c582b2d"
    sha256 cellar: :any,                 arm64_sequoia: "a8b28827f545a4799e0055ecebfb40c969dec70d60f46c6d94ce1b06ba49d300"
    sha256 cellar: :any,                 arm64_sonoma:  "a8b28827f545a4799e0055ecebfb40c969dec70d60f46c6d94ce1b06ba49d300"
    sha256 cellar: :any,                 sonoma:        "400e57a081874ef40efe7eb7b8424b038fc92ec53e73031426fad0edf1b0e192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d5f0ebbe439d0105dfb46fad719701a218ee8c350dfebfc830170464496d600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ccdf01151b520cdf7d9e4c23cb390d7619f20eb07dc2595fb58bdcdd2957543"
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
