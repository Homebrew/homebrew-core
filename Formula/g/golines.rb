class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https://github.com/segmentio/golines"
  url "https://github.com/segmentio/golines/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "6f3c462dc707b4441733dbcbef624c61cce829271db64bd994d43e50be95a211"
  license "MIT"
  head "https://github.com/segmentio/golines.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0253679e4f9c75f4481d25f95b06b22c67f7436b62120053fff951fe895be818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0253679e4f9c75f4481d25f95b06b22c67f7436b62120053fff951fe895be818"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0253679e4f9c75f4481d25f95b06b22c67f7436b62120053fff951fe895be818"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fcbf1297b553332b33fd8da6646afd895379ff3614cecb10eebd844dd0031e6"
    sha256 cellar: :any_skip_relocation, ventura:       "9fcbf1297b553332b33fd8da6646afd895379ff3614cecb10eebd844dd0031e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1869729349e1f224e3e615710ef606a79cf3bba1e03225e2633a78497fd5ee12"
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
