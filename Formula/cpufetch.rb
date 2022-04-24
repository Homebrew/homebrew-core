class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  url "https://github.com/Dr-Noob/cpufetch/archive/v1.02.tar.gz"
  sha256 "3d1c80aba3daa5fe300b6de6e06d9030f97b7be5210f8ea4110de733ea4373f8"
  license "GPL-2.0"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c67924a56c6098beebbecc16903b45b0893def8a247443054e8805befc3370e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbb7d74ff6b3a74ab4d3835364e3f08d20b02496166f4b940466ee54d6e4dd80"
    sha256 cellar: :any_skip_relocation, monterey:       "2f55b89631b7cffb0f9bcc5097fe9b3ecd057fa97291749ab624091e29ea7c96"
    sha256 cellar: :any_skip_relocation, big_sur:        "436945327d23a07bc8c9802eebcc7b1dc37ff464d599da67be4bc73d30cef0f0"
    sha256 cellar: :any_skip_relocation, catalina:       "584914bb5e2443fda98fe118b5588e49d13a802933d32229b134b33d30fd5c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d478551d7320d3b977d64d86df98ca181db8ba37aef3654670ce522b378ad83"
  end

  def install
    system "make"
    bin.install "cpufetch"
    man1.install "cpufetch.1"
  end

  test do
    actual = shell_output("#{bin}/cpufetch -d").each_line.first.strip

    expected = if OS.linux?
      "cpufetch v#{version} (Linux #{Hardware::CPU.arch} build)"
    elsif Hardware::CPU.arm?
      "cpufetch v#{version} (macOS ARM build)"
    else
      "cpufetch is computing APIC IDs, please wait..."
    end

    assert_equal expected, actual
  end
end
