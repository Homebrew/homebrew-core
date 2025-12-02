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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5d5a9189ea3987bd6e684906bc7feaa24ecc97e91b2fbb278fff588b8309cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7952f84e2b24a544cc3b0a64b30349ad5915ef03856d8b9f47c4784e98b41144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ab16d887637a3e8b656d36a839e5496e5b37b040ce1d7f4a7bf85c9aba50ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4c121b6008fa8888b35dca21d034b74423aa472560ddd7057282eea9d5426a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b7dfb23e4bef35a50db2397656881fa11e75c8e3dcbcb44fe77213ce82ee7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "176c6167e25dc1e9706e2985a9872681a77f9edbc3c60b008b4bb5fd0d974599"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubefirst", "completion")
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
