class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.11.tar.gz"
  sha256 "df69962dd769e6fc8be4e78d00d7bf75b6fcb49c8bbccf18675eb1066c125716"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d60acc5e116ac8a3cc267147179cacb0feeee5f9a36b3ec3706cf63c3c9f3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "502581d4017ab9b7390499a64548e734aac9bde91cd64576eeb2858babec0b8d"
    sha256 cellar: :any_skip_relocation, monterey:       "0739815ad15027d18ab113d2af0f753d281042b862040cd6b4a39bd92679618c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd01cbe62a21847d06c277dfafb5b1b3ad8cd6b7174fe351eb136d80a273297d"
    sha256 cellar: :any_skip_relocation, catalina:       "e796e45c3a1ce2795ed7a6d16f2b8584fac1f87042b1efb83fb5b063ed3f1eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1153edbb465f46fdbdf43ccd2d8c7b0aa906ae0972276afc105be9bf95c6933"
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
