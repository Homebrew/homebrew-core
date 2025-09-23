class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "b695357212711aa4aaaf5e367f7a72db712f8451b925370ac86cd93ae28a5fdb"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c28d9fe512bf35f9816299e6d1783695b5afdcef16fec9c81fe9b9061cfb79d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5906693a33288eb74753ce5327aef1700173ad75f285c4d9c0730b77f770c28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "034c6dc25ce92215216f51a7b4fc1945e64e67131c5819acf25a781c41cf3b83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99e4c078c2453fac6dd82cf9759c739f21afe6ad9d15d1d24257e434d0b4795c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0be92edeb0faf088841cf918562efb66851c762b999c9a07134d6db2214db6"
    sha256 cellar: :any_skip_relocation, ventura:       "b49be7ca0ed6493d46db1c1406e0a7f87ae1d2382f41bb2d844ffd4ca6677a19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a693c55ba568d43d6485f1fe4264f6bc1d65e1a1c7e6be1de0c067d786969f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87842f7936b1addda120544b737e3c39fe38bdbdbdcb7870e6e8cf43b9fd0c0"
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
