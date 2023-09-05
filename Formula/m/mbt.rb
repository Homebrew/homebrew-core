class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.25.tar.gz"
  sha256 "1c13e9bf07228b238e7b4b43841428fa3cf2924adc124c157e51d9b6013e0f3e"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f8c47d26c21854e75912bd863d6af8c36fe3d007850b4b9eed94e973e170b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e9626b386bace246a2d3c55f9dbbaf62da8818e3651299766a198d934e3b0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83d8075db7afea337bddcfc6bd89ee271ef37a8f0f8e442aa40d95cef8ea32e3"
    sha256 cellar: :any_skip_relocation, ventura:        "28c79ee4e63eaad64ed6169ccb0de2a71d0e490bbb0485c0324c97bcc300b0db"
    sha256 cellar: :any_skip_relocation, monterey:       "71199b2ee2078bfbdce574972c361a0b4f1e5346e532126ba19b4e35b7fc7754"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d9e7a29f9014289de8ee0d945a698d776685252d2750fbc1d131191d249c93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a5bfa39f64d70faa78d6defb75675b801318633f44c685ec46a9a8e2227ee77"
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
