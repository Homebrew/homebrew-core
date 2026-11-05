class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https://github.com/golangci/golines"
  url "https://github.com/golangci/golines/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "8cc653d7451b526edcc61b6dd51e7ac07815f6ba93c99a350495d97e02661ae0"
  license "MIT"
  head "https://github.com/golangci/golines.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c228fca8fc8980b430f48e7ea8223993552e5191cc7fbda59afd7fab8a06e2f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c228fca8fc8980b430f48e7ea8223993552e5191cc7fbda59afd7fab8a06e2f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c228fca8fc8980b430f48e7ea8223993552e5191cc7fbda59afd7fab8a06e2f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d38e864dca87998bc18e15f3e65d68dea0690c2011bb9c9fa7172d110473267"
    sha256 cellar: :any,                 x86_64_linux:      "005272e8fcc097862b826b3be8d04ba88ce8cd7a7317799c1d18362ff2afb4e8"
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
