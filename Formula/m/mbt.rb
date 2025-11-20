class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.34.tar.gz"
  sha256 "831450c20115a2446513629b71597ae1dd6d81d185cb65a3d49fba5d1c7c220d"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4db3e97e080a28ade4ba714052dcedf3a55453bafc41c2fb84508ca12c0a2018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c402f06fa3ad380a2cf919861555eb18c0a1c649a9d772c84e96251ee8beba58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c402f06fa3ad380a2cf919861555eb18c0a1c649a9d772c84e96251ee8beba58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c402f06fa3ad380a2cf919861555eb18c0a1c649a9d772c84e96251ee8beba58"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d0083779e2224e44c5b2a942c1bd455ffa9cf02f74c5ec3599fa2b906b6e3c1"
    sha256 cellar: :any_skip_relocation, ventura:       "8d0083779e2224e44c5b2a942c1bd455ffa9cf02f74c5ec3599fa2b906b6e3c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad417cb29acd148b1379645aaa8bc7df579813f5e32fd44bf3f9a44ec2a42681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de1733d1f33b1497ad216370c7301b8414cbb544db4376581feddb0869db12b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
