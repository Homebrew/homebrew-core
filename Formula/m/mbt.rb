class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.49.tar.gz"
  sha256 "2fad4220c91a2cd65b055cd80ad4eac265a2c608ab21d0c4c974ceaceb1df524"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "682eccadecee91e4d8e39c95c12a05b362b185b80130ed82e4a771719e92be68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "682eccadecee91e4d8e39c95c12a05b362b185b80130ed82e4a771719e92be68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "682eccadecee91e4d8e39c95c12a05b362b185b80130ed82e4a771719e92be68"
    sha256 cellar: :any_skip_relocation, sonoma:        "a488b709329ffe18ea54d1c2915ab3a33eacc1d85951574c38760baff39cd2ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58e47a88975233cd653229bd753fc860b556a85bef08aef709d43c2c78a2d290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ecf32deb44316832c57d9efe142467a0f3901d224b2f5f3732dfd9b9af24690"
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
