class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "261977fda723d870a49a89f953ba9b76c72813d4e8f6ed1e87b58dbe5a0bec93"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c667f2cb35e6419b87d2a54ae39ad5aa46ae9d9f937d83635820f027b670d1b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "489028de9165e0e5b5809d8ac8503321ed92943b1f709b6a0c64a929410a5e51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa243bf3164d832e1d2d51ce46fdb00042735f73fa1326ad08d25506bb3acd6a"
    sha256 cellar: :any_skip_relocation, ventura:        "b35fafd8127179ed63c96614a9d98922d1ae2b7b9f0dd0c809027480e53cf105"
    sha256 cellar: :any_skip_relocation, monterey:       "50e43e89a8aa0e262c15607197e843b2e2e002f90505c767cec3a19999735e7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a276496e89e824d06f19d2b87d88099d3da20b174dd62c74ffad1a7649c3dacf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e241487a9c6cb6d72c95a60b234305751da99f27b0a7e0321d959cf15d0f91b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end
