class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.5.2.tar.gz"
  sha256 "bfabe08b914aad6a172ba32ad03ea6794d4f556c1d32e38d67feffc6a05bf4f4"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ab27a5aaeed5e78a2fa8189192a6589ebc022523a59a6485ae2e6ecd01b2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b95ca8a6a7c0ffb5b7de5dfd8e09a1d3d1c80e5ce57aee0af11e7ed6df734167"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5432c2dc0af75762b71093139319ecc8c93a6eaa4d4b4b78353d63f845f59aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5655d700bd9b7f128cf5116319a88a5ccd8c4a623d6da6540c19799cadb03d39"
    sha256 cellar: :any_skip_relocation, ventura:       "f1ab77315b49553f8d8701d8f48ca2df07855cabc9bb9f9e7eaa11217c250a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f55d1695723f526b079f6bd61840e64a46024352a636321fb2d37c425b62205"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=brew
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end
