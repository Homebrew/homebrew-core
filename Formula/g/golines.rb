class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https://github.com/golangci/golines"
  url "https://github.com/golangci/golines/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "0dc245339b1508d6489950315d46ac1643a70dce40d172e85b6bd9e6bd6cf6d3"
  license "MIT"
  head "https://github.com/golangci/golines.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1768a0b88ae03962ccbbc4ecd02dfdb64573d1e1588c9814dbf4c226067c6662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1768a0b88ae03962ccbbc4ecd02dfdb64573d1e1588c9814dbf4c226067c6662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1768a0b88ae03962ccbbc4ecd02dfdb64573d1e1588c9814dbf4c226067c6662"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b246f8fc0182e890e8babcce81df93ddd30c933f225f307b436436e74fd8ada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245d523aa725056d03ded066dbd317349ad1507a6fac5acf08993d6b12d28c54"
    sha256 cellar: :any,                 x86_64_linux:  "3acd39b31187c3db07ad21275a8783a2c49f9da3ac034e032d15425b7e81cb9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/golines --version")

    (testpath/"given.go").write <<~GO
      package main

      var strings = []string{"foo", "bar", "baz"}
    GO

    (testpath/"expected.go").write <<~GO
      package main

      var strings = []string{\n\t"foo",\n\t"bar",\n\t"baz",\n}
    GO

    assert_equal (testpath/"expected.go").read, shell_output("#{bin}/golines --max-len=30 given.go")
  end
end
