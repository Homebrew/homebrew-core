class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "c6b9610279cd510d672c585464bf1330c80e4ec8e6d3530f551b83ca692ead37"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3717e2bc74c06f029c993773841e2fa5d1c35bda98f463a2a8854190f37dbad6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb968c932c3c2129ab2aa12693c25b819dbf653a55b6ea0cff9b1f84b79a568a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89f5f044aa3dbfb3befb1cb901361024f9f8f6d3a39edf00b00caa0373810a37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20cd9bd10f6f0aa92bbced073c242c82d20e8d5dca1565ded4eca8543b69c1ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "82040cc598897f45e1b764b3c5f7a1d88fda08e29aca6b0af3d82fa86769d166"
    sha256 cellar: :any_skip_relocation, ventura:        "bb190ea1fe675fedda583a835941936f945febd2d52810304e97182cebf26b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "4844c8c9bc31456a322df9ae21961d80903b7d7e5a4c5840deca54ada3517b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6e552e1b9c8f6d3a8138ef89d17cc93b4bfeda15da69cea2f1d535daf4df0d8"
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
