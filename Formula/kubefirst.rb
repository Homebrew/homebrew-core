class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "3bc11839eb73728dd1d42e8a3fee17321469486b56b6c79d3dc3a59e2e36b668"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34921cfae22518b661ce571efa12bff70d6864c9d7d4f9ad57447137f9d98998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81c8b75f343854d7b578855f4b3de35c00f95356e43ca9cd6c0597c4e1f84d2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "822a74a08d8f67572cba84f5c48e9051210ce4b91207617e61c136ef4a3ea095"
    sha256 cellar: :any_skip_relocation, ventura:        "9b07b3e9a8d517f614e7c8eec4ee3e67601ec25633ca3884f98999810c746b90"
    sha256 cellar: :any_skip_relocation, monterey:       "bd297cc49f56cf818bb4c891205eda2b0860671a9e6f1ae38ffd591b9d8a7677"
    sha256 cellar: :any_skip_relocation, big_sur:        "de8ee36b8b2a61c66740f6445dd0fb8f6473a73e0522182adad6563a2ad5304f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bff1ef03c7cdfc6cea04117535f904cdd244a6277909fc60c212a341b1ad07e7"
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
