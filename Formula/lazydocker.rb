class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.13",
      revision: "048c4c9731faac6ab240c7fa8feb9b79dd95343c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5206bb97f1b97937bd3a7f55ef60e3cdcf7dcd11a528213669647ed5624dd87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d5fc99b6f69ee9397be2f136247ad7d049419144de1fc6cd767ae229c93385c"
    sha256 cellar: :any_skip_relocation, monterey:       "513c7b6ab8549e9e59a31172167a69b1dd96ed4c3c20147b42174ae32ab725d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "abadea905b75a2569f452f77a19126057fbfb2a702e982e3bdb01a8308aa3935"
    sha256 cellar: :any_skip_relocation, catalina:       "67e73e0d74ff5920cdfca6c786b729e18207166d4cfb1b7237f981a57ab494ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb946c3fa3d69068bd29ffa13eb6bbda0d987bf398bb60d34bf9c1dfb01a2007"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
