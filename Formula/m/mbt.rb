class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.51.tar.gz"
  sha256 "fce8f6d915693fffe6b0c1101391f8e145854ecc761b5d7001ec95e8043044eb"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26ced2d0d4d37e5b11577486a298acab7d7133586bef15e2e5ab2b24a4598475"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26ced2d0d4d37e5b11577486a298acab7d7133586bef15e2e5ab2b24a4598475"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26ced2d0d4d37e5b11577486a298acab7d7133586bef15e2e5ab2b24a4598475"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "479e19bea05f2b232764bfccdbd4cc1e1f1495d3479a45d8bd56d5c26c49e663"
    sha256 cellar: :any,                 x86_64_linux:      "546ac48ea2ab0d18cafc7795e39796210666d2ae0a11d35615cf8a18e10de7e5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
