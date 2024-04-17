class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.5.6.tar.gz"
  sha256 "9cb4d8652d6bd3700e34170afca3cee31143e70ac588dd310b4122c2f1be53c6"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62d19d0b311f9f63d9368dbe90afa02f3e85be0e1578c55979342fec7947f7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c60be3b65db31b0ed9d881515821d2521f901629d1c509e3a5eda7ba789036"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fb8aa4a37c3cbfeae425f093b5ed8ba3cf3eaa4058ad0f1f5d56de76621ca40"
    sha256 cellar: :any_skip_relocation, sonoma:         "08f2af5be13581898c50d43d84fa9d8f1ff25fb5c91ffdace5774839a3731353"
    sha256 cellar: :any_skip_relocation, ventura:        "50fba2b7778ff1b5533ee50f248c198557a705308ef31c6d76658f320872af55"
    sha256 cellar: :any_skip_relocation, monterey:       "6d1bef3ab4049be7a484d972aee8ed0e25dfb38466fd56a6ccece908ed4c95fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e9a8089a186334920117ab2edc23cedc31d2ba62cace4ce2dc7374e588b837"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate testpath/"jobs/brew-test", :exist?

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
