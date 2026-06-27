class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "91112d5f07bdcfdb4f85a9da79968f6dc9c2d352d03a50b275f3fdd06b9f8364"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a787be0dd2873b9245890777b5969bd8e8fe950a155b504d2bd2d53a25eb0a77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "848d1c698cdaca90d400bafc245a0899d2fa47cf8b53bf917648476d0b8536b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b274d84b093a3b7dcd1aa030c254ece32eeed200754eee6ffd8c0e34a88903"
    sha256 cellar: :any_skip_relocation, sonoma:        "d789de6c70a00198a232377c35a740af086955918a02e2b2be3108657d3826fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebb9c7b8df316e084f36b9d94a7c23e0a97f4356a5cba7329aa1548d6b12c16c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed715b1c1e36cfbd51549035bcfbae683620dd91fe4ed22bdc9d672043e7b997"
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
