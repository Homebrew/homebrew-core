class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.17.tar.gz"
  sha256 "cb0d4e265b7bc2c75c2a5898dde3af126a2bc159b203cd61901611149f8d7433"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fba5fc8f5756219d212160b27f6ffdb941b9d53ca1bc57f6dc9da4a09000ee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "563b61c9e5ee02b9e4f85a75bd58e74a1aa1fdfae7ad9b075000d12af08cc5dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d5cb90d83642b1576e6a3f4bf7301c839a3371766f6c91965fe11c2db37b36d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50b02b8c5364a5c41821600ced58be5ddc009ab00ed61174bc29e883321fed1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ad1a9600488ca02a442593d0e9ec4becc7ade67bbf75d2669e17e6d8d1fcb8d"
    sha256 cellar: :any_skip_relocation, ventura:        "4de2288766dc8c673cae5a3086e2676b57ecd954b10eb94bf658c55454322b88"
    sha256 cellar: :any_skip_relocation, monterey:       "42e28bf6b75e2149749bfdf30f178528688f37d756889ec87942b36df46ae135"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d73fe8aaf8ff391a60e51a3fb3a48abcf1a7a9ad0fc12ce3a3ca91e4bf0c236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78b87bd5290d252af468fe4ca52b766c221950ccb4b196bfd117c029aae3acc4"
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
