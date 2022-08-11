class KtConnect < Formula
  desc "Toolkit for integrating with kubernetes dev environment more efficiently"
  homepage "https://alibaba.github.io/kt-connect"
  url "https://github.com/alibaba/kt-connect/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "c29d4d9a18defdd8485adfe3a75b2887b42544fedd404073844629666bb28c9f"
  license "GPL-3.0-or-later"
  head "https://github.com/alibaba/kt-connect.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "201a9bc8a61ee90706957c3fccf6ae1623639bda3820fb50ff1a80648935bedf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8c5c2566756210068ffbd9de28df50a18509e9139089626d739a31a16ea01b9"
    sha256 cellar: :any_skip_relocation, monterey:       "5121833c6caae40c1feab413ca5ee4df9d8148ec4bc4135eb94d2beeadf3dff2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f34314cfc0ea7d23bb903b074d55b1694c8ec001b037051c5622cbc2e8262654"
    sha256 cellar: :any_skip_relocation, catalina:       "0de5ef15714fffa9cbddf23e60afd497e2fbf3a39f29b0f8f062f92aa26fb031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42feffd67e8c7bad19c91931a73802e3f65321ddbde2b405fa225221d00cdc31"
  end

  depends_on "go" => :build

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
