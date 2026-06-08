class JenkinsCli < Formula
  desc "CLI for jenkins"
  homepage "https://github.com/jenkins-zh/jenkins-cli"
  url "https://github.com/jenkins-zh/jenkins-cli/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "4e78600e214c357c08a0a83fe9cc59214b0d050de07dbb469d9f226c8c37eabc"
  license "MIT"
  head "https://github.com/jenkins-zh/jenkins-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff9e6197d69c4a7985cafc84070c77acac3fdff42bb3df03ffe95de4af87856e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9e6197d69c4a7985cafc84070c77acac3fdff42bb3df03ffe95de4af87856e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff9e6197d69c4a7985cafc84070c77acac3fdff42bb3df03ffe95de4af87856e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9304a3673e5d1d11a8252881aaf88adf34e3c98cbe4016270266cba44ca6201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fc2d7c33e7fa4505e9964d32fb6be2e2078dced05297e9caed10dc16c95da30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d8ef1de256e33c0e720c27b012510e9ce092cf4431a41437ac472318f5af08"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/linuxsuren/cobra-extension/version.version=#{version}
      -X github.com/linuxsuren/cobra-extension/version.commit=#{tap.user}
      -X github.com/linuxsuren/cobra-extension/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jcli")

    generate_completions_from_executable(bin/"jcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcli version")

    (testpath/".jenkins-cli.yaml").write <<~EOS
      current: default
      configurations:
        default:
          url: http://localhost:8080
          username: admin
          token: admin
    EOS

    assert_equal "Name URL Description", shell_output("#{bin}/jcli config list").chomp
    assert_match "Cannot found Jenkins", shell_output("#{bin}/jcli plugin list 2>&1", 1)
  end
end
