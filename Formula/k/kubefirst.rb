class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.4.8.tar.gz"
  sha256 "cc27847641a60892c933e139780f107e68e29f279d745e77f9dbca4229df00ee"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a7ed651b21f8c89e07cdeac9dd0ae7dbecc1d7740ab7179ae2b83931c183e3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90cacd36b9688187d96821678693490fad9e6abb1058b2dd56f8266c9e5f52f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c5ba274330172b994af53a7f8bc7ef78fe0a696e06e694ec8079a6fa017ec3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e9210a79cc8a1878a01445e431dfb5de33c139e2b365d7998e96fe6d6914aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "86840625489e1f92cfbe5fbbde7ebc644252a14fe123b8c458a10bdfc6cec1ca"
    sha256 cellar: :any_skip_relocation, monterey:       "6940513467a932d1b9babc40d5125790557a683ceb03c909cbc9d35fbd767fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d706cc274cf1075eaee1b8bdd8cd29fccef0acf1ed0196ec0507ebf65953718"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
