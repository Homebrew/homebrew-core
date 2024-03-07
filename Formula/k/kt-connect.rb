class KtConnect < Formula
  desc "Toolkit for integrating with kubernetes dev environment more efficiently"
  homepage "https://alibaba.github.io/kt-connect"
  url "https://github.com/alibaba/kt-connect/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "f32a9eebb65bd6c43caaf7219a0424dcf9e70389c9a471dad7dc6c64260f3194"
  license "GPL-3.0-or-later"
  head "https://github.com/alibaba/kt-connect.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dee23d253f401d36476a08a6150c453eb9ad696f2523cd71f3bc35a35159dd88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5774ca3a0f1d79dc09389bb90a27b34f7c41521f77f834995db7b6e3ad325364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9512325d69b9c0894706ea7f328ab385e707357127db8d55445119ed24891e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a4ac7a4168713b0571a261a19c63bacf773098a4aa1740d8ba6af11ea45ac78"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e331766638f80e9b35725fa47c6f49064800c79a1e8498e955c836f01efa5df"
    sha256 cellar: :any_skip_relocation, ventura:        "fe2ab936924603f41a8e57c108006002ec83bec88e2e8bdb2b26f0bf83c693b0"
    sha256 cellar: :any_skip_relocation, monterey:       "dffdfcff2dea1eab76dabc61a48edc7a41ba08bfcdddb53f94c1e2e750111555"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b9f8b923ec3fef27e04e07785d0b2dfc837ff3daf944063a8f2a8990fe213b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ac819a53007214f4d5e59877c0e5caacb17bd4e777993a89cbdd6383884ed45"
  end

  # upstream go1.20 support report, https://github.com/alibaba/kt-connect/issues/398
  deprecate! date: "2023-08-20", because: :unmaintained

  # https://github.com/alibaba/kt-connect/issues/398
  depends_on "go@1.19" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ktctl"), "./cmd/ktctl"

    generate_completions_from_executable(bin/"ktctl", "completion", base_name: "ktctl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ktctl --version")
    # Should error out as exchange require a service name
    assert_match "name of service to exchange is required", shell_output("#{bin}/ktctl exchange 2>&1")
  end
end
