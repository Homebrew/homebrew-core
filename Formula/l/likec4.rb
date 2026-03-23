class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.53.0.tgz"
  sha256 "d3d4d278fe62b2ba1486336180988856970085b1631ab1d68f19deecb2ea8d44"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cd9ed3f48bff7a3da5fa034fd29148269b0972fb1f603c0f747407c00665b93"
    sha256 cellar: :any,                 arm64_sequoia: "63aa7d1b31eb65751ebf415f73b75fb357b8f61a1ff119b652a261401c493b78"
    sha256 cellar: :any,                 arm64_sonoma:  "63aa7d1b31eb65751ebf415f73b75fb357b8f61a1ff119b652a261401c493b78"
    sha256 cellar: :any,                 sonoma:        "025f4bae8cba43050ab8b29b07f77cd4ba4a897d13ea3ceddb7352b4cc1ae40b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef865ffd95a963ab8865960f2ca14289ef23c1ecfd8dc2200b0bb8b330a8868a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30fe5f6d2782c57442e3865ca3971470384805d46b4c464c5bcd4283317b2175"
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
