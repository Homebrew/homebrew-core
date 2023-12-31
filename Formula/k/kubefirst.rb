class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "7e6809854da3f71aea99dabed6e85cede4e4d24ce783142a027e3879deae2bdd"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9640f9bfb88f4e1ceaffd344ef72b7ceb29c03d523066012eebf4fe431f13b1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4c26e13590e474426a3fbfc6636962137eb0ee4b45e1fd7dc11cbbef65c5475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "838cb4c57154a497c18abd335453796c71d021e350cfe1f639e616a4720c6366"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a8f225606edbec192e270322a94fb0f3d0dc22336d1263690ec42e3f8c657f0"
    sha256 cellar: :any_skip_relocation, ventura:        "60d80b806ce3bc96c08ae7c7ee1ab155ef1b7428ba5c24b08be0bcd3d3e03475"
    sha256 cellar: :any_skip_relocation, monterey:       "5fe6db88958a7ccf725e76fa616fcc73329138f727f8bfb7019e1120527b3dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85a873d86e2e09dc72d0fa77947c95bf84b80eb6cb2f4ec6260b4ae75451996"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
