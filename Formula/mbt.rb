class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.19.tar.gz"
  sha256 "8c856b8832ab5b4afb5c03f3d9073401eed8e7ee43fbe0cfb343dd15ba1e21be"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b8f1935ab344ed113ef8e4f28702c22391ea58f4ea435ec552c1e2731422278"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e54dada7b941727e183780ec6a88e20557bb37e4fe3d283b2c2c37a30235401"
    sha256 cellar: :any_skip_relocation, monterey:       "28944655a5f32f4d74b75c8ee8e43362ce21bb18fc0d1ee4c333a07c1033243b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7f95b1be115c133608279c9835557b626dbb66c5cdadb186a692a2dbd862df9"
    sha256 cellar: :any_skip_relocation, catalina:       "d10a9c37baab581d378e45a485243766249141ec247d2f132a8d2ac7300afd15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c4a6a1ba85e8cbc8e266ba03a17ca366efdcbe06a82c6df9ee4b0a111860353"
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
