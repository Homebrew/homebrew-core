class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.59.1.tgz"
  sha256 "3ccea83cab81a4294f36bebc85506457380d05acd3d3c8e1099aa47de5a75d8e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1438f7641ca4126a9c26b07b7756e95f0fc715dfca022c8994cc88a0f4f6f89e"
    sha256 cellar: :any,                 arm64_sequoia: "1438f7641ca4126a9c26b07b7756e95f0fc715dfca022c8994cc88a0f4f6f89e"
    sha256 cellar: :any,                 arm64_sonoma:  "1438f7641ca4126a9c26b07b7756e95f0fc715dfca022c8994cc88a0f4f6f89e"
    sha256 cellar: :any,                 sonoma:        "a0f6c50f8883b1bea3dce827b601adc9c4af14a532fc4d2fe05a0a116879b517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ec2c64c2fe0c89e5c4c979beef6ae274d6aee18b8906ae9df1d04522580594a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1a5531a7112836e0dcedcb9d9201953efd63eefdb2d87b9b715cbd6a8eaca4"
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
