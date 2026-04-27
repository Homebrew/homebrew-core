class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.47.tar.gz"
  sha256 "e7db5427f134df25282722e1800db8212dfdfd7856302bdbdb3e57e90470b257"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39eef2fa07db1261d6a7649550e09802c5e4adcebf107f0ba32d7b7d446c09b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39eef2fa07db1261d6a7649550e09802c5e4adcebf107f0ba32d7b7d446c09b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39eef2fa07db1261d6a7649550e09802c5e4adcebf107f0ba32d7b7d446c09b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d11307b9aa3d189758a4ffc9c568cfa422aa1c3a42b75d7180b96e1585b924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e54ef4c9d455b2805595408d644dc367d4821ee12c319ef83db3125006bf3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195ee0d60717e308af29809e34053f65534defa8b1845a053f1743b50c9bf190"
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
