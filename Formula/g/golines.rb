class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https://github.com/golangci/golines"
  url "https://github.com/golangci/golines/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "8cc653d7451b526edcc61b6dd51e7ac07815f6ba93c99a350495d97e02661ae0"
  license "MIT"
  head "https://github.com/golangci/golines.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "928817ce71f8528144706d58cfd8955c5707c700e5a2c507077c1dffaf3f04e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "928817ce71f8528144706d58cfd8955c5707c700e5a2c507077c1dffaf3f04e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "928817ce71f8528144706d58cfd8955c5707c700e5a2c507077c1dffaf3f04e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "292ae7465a357a3dcf49d3ae6379644ad9d76f0e9e6b12f68f76f12b85de3e89"
    sha256 cellar: :any,                 x86_64_linux:      "34fa9d08dac818747076ce68253c0f51623df3c7186148214646ea16fe5f7408"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
