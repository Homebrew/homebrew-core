class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.23.tar.gz"
  sha256 "a98f06248336d18b24b8da80a2f289f52bdd58adc41c34f048350194ad7e7831"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2753b2144568964c3dd6862307f98ba37fb5fc545a2d41fce7a90e841360fab5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9602f32c8a1aa9a92571bf4d83c20ae33c664437d8e4e936b443b48cf2a873c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11d863598843d84d9e783edd3b5bf9fba5dc1ffc488b36bbfb987451e7ea898d"
    sha256 cellar: :any_skip_relocation, ventura:        "a1e72ddcd80d881bfd06a20f2d3593f8ec3c44c7cf874631d21786badade817e"
    sha256 cellar: :any_skip_relocation, monterey:       "5927ea25135f951b4ec2baa4cd811416d2faded995a25ceeabb41bcad025f610"
    sha256 cellar: :any_skip_relocation, big_sur:        "88293e3850cde169c7c469a0bd29c8d8b27cc45fe34f5dddefde67f7ea69be7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e79844b27a62513df0d0226787368975d5bef04d017f30c2db418b4c43973b38"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[ -s -w -X main.Version=#{version}
                  -X main.BuildDate=#{time.iso8601} ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
