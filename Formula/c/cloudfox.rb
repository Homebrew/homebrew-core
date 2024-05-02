class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "5ed07d0c80a9cc8a3f30e282be79cbde17c670cfe624d852644933827367ffad"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22ecb59b1357ceed260d0fc5d1a283c8c1e06a931b39aa6805a3a9e76c9bef9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "debfec4d936186762d8236c49e46a5685921602e1e9f5a1db563ff3280a65268"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "369ace173978fcde6548a65d84e537d6619fc638566571f0a9f16485ae36cf9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5dcc5ebf0abbd33ddda5f445eb61b8cef3d81edddfc8b5f64b403a502cdee49"
    sha256 cellar: :any_skip_relocation, ventura:        "2ec62b3293a4efb726bc107c18f2f4e994781d6b53a06122ab78cc53007e835c"
    sha256 cellar: :any_skip_relocation, monterey:       "b9676359f77fd08d2c8477a510878a13e98cf87942205ae0bf0eee057dfe033e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f49e8192323ab83ead782018be4eba01822980eb8c586f4c2fac6447371dd529"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
