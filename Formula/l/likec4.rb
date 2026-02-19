class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.49.0.tgz"
  sha256 "2ab93034bfd1684f1fae8655a751c56dc0fbc53f4e1e27e1d3391292a4dafefb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff95b72ac54890350e268d29a6594d5bac0fd9296d2c41046f2fa24aefedc329"
    sha256 cellar: :any,                 arm64_sequoia: "4e3fde311a235da6624ae7fa7bdaff19ee1ce5ae259d9f4c2bc127eccd4709e4"
    sha256 cellar: :any,                 arm64_sonoma:  "4e3fde311a235da6624ae7fa7bdaff19ee1ce5ae259d9f4c2bc127eccd4709e4"
    sha256 cellar: :any,                 sonoma:        "f2b6d4f6873d400e61ede5ff6ba30b8c617490d6e5ed702cd0d31c8ef227e9c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "912ffb6e2c645a9fcefcbd4cd8329cae26005b2fd2ec3486b8f3f173439cc571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23de0532c67bd02c0eba6496eace9ce1aa159424420015cabe8f7a8d27c4a199"
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
