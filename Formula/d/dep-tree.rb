class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "c6257189f94d3ff5bd37a178168c8274bdcb3f3b4fc874061c0cbd7f53ed65d2"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ae8e97ced7faf8f6c1afdf91cc2e8ede125dec3fbf07f0c2579a4223b42434b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae8e97ced7faf8f6c1afdf91cc2e8ede125dec3fbf07f0c2579a4223b42434b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ae8e97ced7faf8f6c1afdf91cc2e8ede125dec3fbf07f0c2579a4223b42434b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d3154d8f8051e30fa147cffa844920960a88c38fd57f0f6130923cca5b3a981"
    sha256 cellar: :any_skip_relocation, ventura:       "8d3154d8f8051e30fa147cffa844920960a88c38fd57f0f6130923cca5b3a981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b5cfb0f6b9c8780c1280372825ea6ba1517b65a83ca21610baba8ca346672a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"foo.js").write <<~JS
      import { bar } from './bar'
    JS
    (testpath/"bar.js").write <<~JS
      export const bar = 'bar'
    JS
    (testpath/"package.json").write <<~JSON
      { "name": "foo" }
    JSON
    expected = <<~JSON
      {
        "tree": {
          "foo.js": {
            "bar.js": null
          }
        },
        "circularDependencies": [],
        "errors": {}
      }
    JSON

    assert_equal expected, shell_output("#{bin}/dep-tree tree --json #{testpath}/foo.js")
  end
end
