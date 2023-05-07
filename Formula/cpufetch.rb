class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  url "https://github.com/Dr-Noob/cpufetch/archive/v1.04.tar.gz"
  sha256 "1505161fedd58d72b936f68b55dc9b027ef910454475c33e1061999496b30ff6"
  license "GPL-2.0-only"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5149d2074889219c812f6ca2505e83347ca1534eb9f0892d998a18da03bd404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff63b2b85c84be38b371a3e37367aecd8685c85856b2ca586dfe2f147f940980"
    sha256 cellar: :any_skip_relocation, ventura:        "3253382bd879bd53a615b56906b13fb4d9899c915451c385f659e1ce9b431af0"
    sha256 cellar: :any_skip_relocation, monterey:       "e51fd38738c0ad936bfffb88fe4dc57e8e69c4b023fb0cce5d1a5c98f6259553"
    sha256 cellar: :any_skip_relocation, big_sur:        "46c8c3b2ed335093b4e2eee7c969a114b7213ff6d5342b782dd227cbfb54db43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5949883510a59f2b7d8f4dd0c97678d249702a879d97bd0978671a983fb0e7a"
  end

  def install
    system "make"
    bin.install "cpufetch"
    man1.install "cpufetch.1"
  end

  test do
    ephemeral_arm = ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                    Hardware::CPU.arm? &&
                    MacOS.version > :big_sur
    expected_result, line = if ephemeral_arm
      [1, 1]
    elsif OS.mac? && Hardware::CPU.intel?
      [0, 1]
    else
      [0, 0]
    end
    actual = shell_output("#{bin}/cpufetch --debug 2>&1", expected_result).lines[line].strip

    system_name = OS.mac? ? "macOS" : OS.kernel_name
    arch = (OS.mac? && Hardware::CPU.arm?) ? "ARM" : Hardware::CPU.arch
    expected = "cpufetch v#{version} (#{system_name} #{arch} build)"

    assert_match expected, actual
  end
end
