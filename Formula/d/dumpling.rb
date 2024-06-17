class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "aedee9e1cdee3703802536aec1b25e54226f773796874faaaef527622250558e"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93fa7f2b40b3eab8c7ac5d1aa31c9a3aa0a25c3dc2df42bbf57c7daff76e877a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a732adf6c749d5fa35cbc9d62478e3ce3eb5940d1250cbe73197425d7f30ce7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e41381ba0b9e2dc06977514fd472e9d39048181600ba71dfadbdd6ad3ef78c49"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ef8e420d3a225e11cb0ac3d982f7381b64a9ce9d42a1c7f030a1937ccb8cac8"
    sha256 cellar: :any_skip_relocation, ventura:        "101632815391b7d48d070ffdcd9b9ff9b6dd10980bc4ff93bb94c720a529d1d1"
    sha256 cellar: :any_skip_relocation, monterey:       "51159e0f5f7bf9a5da7ca345e19ceac4f426a88df43b1dc2a9a476f45408a1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208e8458bca612adfff3530dd5a54f021894dad9f09a5ceed8a44d7ab395cf24"
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
