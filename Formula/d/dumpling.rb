class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "43af645a9a93a71a22430267c9e37572b88ecf949ae60f771a9cfdaecfd24bb7"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ef74f428cf0f85fc10b964cc403ddc1202fe58a727bfd5b2048aa3a908b0c3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f228961a9380d839dc60fe5d7b38670bf90e8c578d19c9663611c2d87f97332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73b3e047b097b2f548f93f97916f53a000755c0343923520b846c8faa96d5189"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4f1ff1a90174428ab9e56159922868208f24acbfa4bc834db75828069ce1bfd"
    sha256 cellar: :any_skip_relocation, ventura:        "510aecb79a3f90febbcf2c3de9ffd02da4b7a964b6d8a89dac7a489fb47b14e6"
    sha256 cellar: :any_skip_relocation, monterey:       "eb5cbcb8aa558126265d5463419ac0ca90a0b2fa479f9e0e4d11545258469c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dc1461ae1a8d91906f1f947a6fb010b7ac656b9586d16fc4dd099963e2f691a"
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
