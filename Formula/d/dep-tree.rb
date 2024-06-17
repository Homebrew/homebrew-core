class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "29738f284564fd71b676232ed9b952bfbf806863dea839981c03556ee6b44500"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76cb9c5be7c17d8af049b132db11bf8f863f6a5c14b5cc477bb523c970d52393"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b88254d07dfd4a43e0eacd74e410beb1989138080c9fc53b7652f7585314dc0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a458f2cf58915d7cd4becd3b1c0e5678b5830bc1d0a11c80252befa3493a0940"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdb35981f53bf094bad47cdcc58fc5a05c33fc53ed1fb60a7513e2fb61a3324f"
    sha256 cellar: :any_skip_relocation, ventura:        "7f150acaf0cbe18b7db2cfacc133315cd3d234248efe38af59e5d4b2d78061b7"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2f9aec7d714c4f554298db84efa3b562c12c9e3ca61c50940b7bd744aed718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3afed66ec3a57cd4ef10e74d1f7d8f27e82465cf18fa52e522380f704a064daf"
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
