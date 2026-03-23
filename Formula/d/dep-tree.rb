class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "84f303594bce854527fe85208867a5060314ff3b24990d7c0f2846d364d81d4a"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db5b0ba7c68023a7131be5df7f465f19b3e648954cdbcc32b18a64de497e6b5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277fe984bf29633301f181b12e8d447023ed0424dea708b6e32f48b32debce3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "277fe984bf29633301f181b12e8d447023ed0424dea708b6e32f48b32debce3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "277fe984bf29633301f181b12e8d447023ed0424dea708b6e32f48b32debce3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d53ad18af48f54b65b6ef9660a05f770517521c78864484a9c5578c596bd3fa3"
    sha256 cellar: :any_skip_relocation, ventura:       "d53ad18af48f54b65b6ef9660a05f770517521c78864484a9c5578c596bd3fa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d5805e360613eb12e4edf87da4ce8087ea292717af71ff5101dfa67f9710d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79b4c548fcefaef96ec701766efffd0d20fa2a412d52d8d26a2f51a4e39fcf73"
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
