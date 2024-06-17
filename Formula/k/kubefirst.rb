class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.4.10.tar.gz"
  sha256 "cab2da24723db63089244c58b5c2b8c287b1169ce9ae41045b7dff573f60423a"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afb5df80e9eca4d860e36ef5ce176c9376c73209ad8c5cfdb3f8edc147902797"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9547ad6ede80524896a07f53a7961ca9f0b7999e3fc4a7371c460794c7ff735c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601534e27534f428dfc91eea3ba201055af772894f43859b9f8d1a497df14c2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1023708623e8eeb1b252277dc7f817c6b304504a6af8eb1f9e1c0443457f7def"
    sha256 cellar: :any_skip_relocation, ventura:        "0fd982fcf4e10b73d317dfe0b4f3451dad4f30c0a3bc4222873bf13c549746d1"
    sha256 cellar: :any_skip_relocation, monterey:       "d457955c6b2c632fcac5ca22c0b32a4d9ff5bdf146320bbe179af51c5c639166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8616715bca278f861157b106e87317d80aa590339a008edae4c0dbb015e197a"
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
