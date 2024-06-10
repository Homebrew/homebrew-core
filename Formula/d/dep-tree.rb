class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://dep-tree-explorer.vercel.app/"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "a671b727ceb913edb041ef786af3eb2f262f75e82bfb31b350ade92db91f26fa"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de4de918fa4afc9aa15a835bb3dc7294c0a09c75d5516f285188397de2b0c228"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1acb315e220c8e6f93cd787858991511e2b2ae68cf326d2d32932fc66d8c5e2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d408d48f6554883ac3ae67608d2afabc93faa9b3bbdff9b9e6124b642d1855c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecf3cca10e837bec040f62b29c424768e8748b018698b3ce2eb19909a2b0733f"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ad97bf3d898e6eb746a22f1fc6a48469db6ef16bc9e721ccf6736dbc107049"
    sha256 cellar: :any_skip_relocation, monterey:       "e3b4babb9c3c3e3ad5687518d70ecc5f3126690a65b2ae08e0144a0e1a7c0bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f105fa826ba7fddcb0409d6ddd65e094e3d98ee3fd3394ae751e7e328db6d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    foo_test_file = testpath/"foo.js"
    foo_test_file.write "import { bar } from './bar'"

    bar_test_file = testpath/"bar.js"
    bar_test_file.write "export const bar = 'bar'"

    package_json_file = testpath/"package.json"
    package_json_file.write "{ \"name\": \"foo\" }"

    result_file = testpath/"out.json"
    output = shell_output("#{bin}/dep-tree tree --json #{foo_test_file}")
    result_file.write(output)

    expected = <<~EOF
      {
        "tree": {
          "foo.js": {
            "bar.js": null
          }
        },
        "circularDependencies": [],
        "errors": {}
      }
    EOF
    assert_equal expected, result_file.read
  end
end
