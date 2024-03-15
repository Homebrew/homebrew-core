class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "e73822f927d7deb32cddb68c61e40641c4241449cf24a0d11ec067b4fc3a6cb0"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8529170bb606d2982be9d82fecbeb98ccd9d0c2e4f03bd66b923936291348df1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a4134b4d4f43b92081f1824a7a290d1ff73246dc4fd8237fffcc0695d89afad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a21743792154757174af8a1030da4469b2febe38d6c75cfe08cae5c20fa770e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f96de4f7e37e94c29410414725f30dc7861ccfd18c49528de6ba2723ba2172cc"
    sha256 cellar: :any_skip_relocation, ventura:        "d45c22039c106acc0795adec9bfb1b01455d77208cfa4c8402fc25556dcef6c4"
    sha256 cellar: :any_skip_relocation, monterey:       "f4c2481f0370be94b3aa4a5124771e460bbf131b56ae29585139a37f038ab398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21598f68c290866f31e0ef19a0b5ae438ce27234fccf9949443b48441b76de14"
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
