class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v7.4.0.tar.gz"
  sha256 "bebf20f649ec12fd7e1c2c86ca5359e9fb1671e677aa56d55a94a6c3c19eac00"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63f5f24eaf2c62045bd7b06835febb1f38fee862a24eb4be2715f818f4d513bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf697ae071e2ae5e0b110e48f749cacaf362da15d902fe7f4a162f76cd5b164b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16a1452e35b5a4413125e47be1add9a702380b14bce8f3ae17f5845544607897"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2dcf1358aac8877d4023ff0a562e8b78ae89f564b76acb14ab9de390b8afcba"
    sha256 cellar: :any_skip_relocation, ventura:        "de552484686ae47ff8a34c8ae3141a4ca7200576e89d2b3d1aa9d9eef27e1b9e"
    sha256 cellar: :any_skip_relocation, monterey:       "0f9615e31f999c60a57bf3ac8ac39bebeba74d17e18f456c8321fc3b95dd7a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c0c324b1b00069db40adb276eb92f042a63b32c45ec2a26cdf69de9de55c24d"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end
