class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.27.tar.gz"
  sha256 "6e9d71b5560b68a89e76033d7738bd46aff5fb16ce41c3c04c2410b00e91889a"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74e185df33a6cfa7349a3f1fa610a56f7676215c08a9f023d64df98e3f38e118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7183f6ea5328a673e3f392f0ff1de5c8e5e7786e09103a70f4776acfeffe5eb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00efdf8946e6b6810fcd38381d0942d5b0662a9a568abaf74f7e4e508b5068ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3a04d74a2b9c52ca4dd6b5f0dc0d6466c99596565c076c252c63a2405abec2c"
    sha256 cellar: :any_skip_relocation, ventura:        "768d9c7f2b16a3a7c81f1df6a3ab6e5008ef7bb7da76a79503f5952b857daa09"
    sha256 cellar: :any_skip_relocation, monterey:       "fa80d2250ee738bb1248b92250a7bbc27c3533982b4ae04a491bed127646a99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f152dd9b126a800a494969b7da0f94a5e940f6aae5879f6ac5c3ac242fabae7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[ -s -w -X main.Version=#{version}
                  -X main.BuildDate=#{time.iso8601} ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
