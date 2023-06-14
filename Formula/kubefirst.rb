class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "d5721e1fc0c80860b6a4362e0d87053cf35d32fb87b98ed7be6d0844dfee1614"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f5afc1b9483cddb18c065ce1621430970056dcc0c18402d44272728cace3aa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a11ba1c81a17b0143923147d98fc7e8591f5740fde17fa67b3f8598b8a01cdbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7ce444f9515d601304909aa42ce26c74b3231c548ede7f92cf885f66f2eef3d"
    sha256 cellar: :any_skip_relocation, ventura:        "030e267517adead5194d5439bee4503b86697795b1fab86e92d06e97f7a45b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "67fa2a1396b0e9598d54eb342391371f0b77728fdfda4f6c361c822e98adef46"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f26629549c61af3c8dc3d01fb61bb3fd265d6c38028628d4fcbf72b79191263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77af6510c592b008238471438d60eefc70d49875888bae5f9d20d748a5f62507"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end
