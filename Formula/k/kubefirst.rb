class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "66758e7675d2aadd86e551f6af1deda76aac0d88bd76a09ae94875dc02100e01"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d87dfce9291db445589af7261ae19a4c671d48656c3cd40bd4d69896a045bfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bc5e0284b97e24a0c41b858ed427e9c5bb82b120e8249aa346d47b487a8483f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95da4ace3bf2f4541eecd67a84ad2af1d94aadb3d85da3bc5edeb300d1cb054"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4340b14799c843882fae04b5c598ebaefc42d22d228d221126619191c53995"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a20afb7b4daa48e7ca61afdce4ed08917cdd99991f005e5fd65bdf7cf4c948d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa05ad28b525df7fba36f7b910aaaa3584f16ef4651426fbf4a3b42182f9a8d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubefirst", shell_parameter_format: :cobra)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_path_exists testpath/".k1/logs"

    output = shell_output("#{bin}/kubefirst version 2>&1")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
