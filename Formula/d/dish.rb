class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https://github.com/thevxn/dish"
  url "https://github.com/thevxn/dish/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "4d8d18b837f03f7c3e03b6da79ffba1865256f2938f3995adafad48cb19a6b6f"
  license "MIT"
  head "https://github.com/thevxn/dish.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02c49400cdaa68fd9d904442a95e3e8cc14b12d1ff63c7e990be9d1b3f22a06a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19198cee1c3db608abf9fd1ac9481db5a4468f620a4cf7e74bb5034dafd90cca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19198cee1c3db608abf9fd1ac9481db5a4468f620a4cf7e74bb5034dafd90cca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19198cee1c3db608abf9fd1ac9481db5a4468f620a4cf7e74bb5034dafd90cca"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bb4679a8537a8fe7f7c305273573950a648e2378ada306bdc9d5e0b86297948"
    sha256 cellar: :any_skip_relocation, ventura:       "9bb4679a8537a8fe7f7c305273573950a648e2378ada306bdc9d5e0b86297948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5af1f11ccfbc8b4ec42a4537d8e40426b366bd04eaa40c470aaedd0910158466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbcb986db8daaacaad96da7f82e9bdfd1efac3a7d50a4df42fbeaa9cc385042"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dish"
  end

  test do
    ouput = shell_output("#{bin}/dish https://example.com/:instance 2>&1", 3)
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end
