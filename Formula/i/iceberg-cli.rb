class IcebergCli < Formula
  desc "Command-line interface for Apache Iceberg"
  homepage "https://go.iceberg.apache.org/cli.html"
  url "https://github.com/apache/iceberg-go/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "fdb06ee9f29195571341485a8b3ed14273b1229c00e1fdafa29e0b33d545d294"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5556e6c250a3fcd5ccf003bc006e7773bdcb1573236faa3b2db969beabd328d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5556e6c250a3fcd5ccf003bc006e7773bdcb1573236faa3b2db969beabd328d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5556e6c250a3fcd5ccf003bc006e7773bdcb1573236faa3b2db969beabd328d"
    sha256 cellar: :any_skip_relocation, sonoma:        "53956640e879b235c67b7061043d0d4e731472ca396d6b46787f733a5759147d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce02a2b014837926202041afd77f5d79a55f40bd51a48b1cb95610a35fd03a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1540eedff89d23e2bfdde840b2b3eb971935477cc0c399f90146b6ed7a1ded79"
  end

  depends_on "go" => :build

  def install
    # See: https://github.com/apache/iceberg-go/pull/531
    inreplace "utils.go", "(unknown version)", version.to_s

    system "go", "build", *std_go_args(output: bin/"iceberg"), "./cmd/iceberg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iceberg --version")
    output = shell_output("#{bin}/iceberg list 2>&1", 1)
    assert_match "unsupported protocol scheme", output
  end
end
