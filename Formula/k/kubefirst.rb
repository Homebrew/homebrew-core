class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "02ae1dfde6e9e85acac77510bc7e87faee5c68cbc1f0a47152366f97459a000b"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c71b427d145be62ee6f0d68f6fef61ba248d9b66ee1c3b09e59967d7150d0ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da206ed66ff371df8fac27f3b3afd7e287bcdf569bacb2dbd0abdd3e638c0fdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f7aae830b3f1b3fba81e02bc54617bca89c69fd02ae0bb3d8d10d9d55313b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "188f9e70f804432636a6661f73dfd96411d76e95230d9adc4e1b782830d96975"
    sha256 cellar: :any_skip_relocation, ventura:        "108cc8c67f55c3f1f6d4820828fec41d6d04e2d8f0fbc90af50c8237485a0d4c"
    sha256 cellar: :any_skip_relocation, monterey:       "40be4bdbc0a35a2682a4f042f4b2edcb757d4e33de32f58a059d806780f75f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0646141cede24c3ff4ae2d8bd76ca86751f977c7e1f9884833af399290ad00b0"
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
