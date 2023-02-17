class KtConnect < Formula
  desc "Toolkit for integrating with kubernetes dev environment more efficiently"
  homepage "https://alibaba.github.io/kt-connect"
  url "https://github.com/alibaba/kt-connect/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "f32a9eebb65bd6c43caaf7219a0424dcf9e70389c9a471dad7dc6c64260f3194"
  license "GPL-3.0-or-later"
  head "https://github.com/alibaba/kt-connect.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "258847384264aa305e719b37c11785a5eee499b573dc49c6575f85d0967c098b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b8a229e1d302e406d135f343c9fe5715a23ca8bcd38b9667a760a85e1f99c5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f8575133862185735f1026bf8378544e307f84f6d15edadea2a15ae1242064d"
    sha256 cellar: :any_skip_relocation, ventura:        "7817e46c79b666b37b30c2ed07ac2a9753a4c6affc0f49d1e16caf7a0b817066"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7c950096ae80e9126b9868e528b98162e9ad42b93b6243f974a4b46a63025b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9a56194f87cee8113b94578482620c1f152882e49fde3e5121069a702601a1c"
    sha256 cellar: :any_skip_relocation, catalina:       "83983ce5fca4ef6597ae46664d7494ac2727d7de1c25483d5c4dd036dc2960cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea73a5753cf517434033739d0055511adc1fa8786e1d247da71aa7837e72f14d"
  end

  # https://github.com/alibaba/kt-connect/issues/398
  depends_on "go@1.19" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"ktctl"), "./cmd/ktctl"

    generate_completions_from_executable(bin/"ktctl", "completion", base_name: "ktctl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ktctl --version")
    # Should error out as exchange require a service name
    assert_match "name of service to exchange is required", shell_output("#{bin}/ktctl exchange 2>&1")
  end
end
