class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  url "https://github.com/Dr-Noob/cpufetch/archive/refs/tags/v1.06.tar.gz"
  sha256 "b8ec1339cf3a3bb9325cde7fb0748dd609043e8d2938c292956da7e457bdb7d9"
  license "GPL-2.0-only"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5ab3dcf28e559af53759e191e76639f453a84a1707c615d5238a2e575b5eb7cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "098d557d887f19ad7094306afcc07f8f0ee0346badd16f704c97df60a01f8c44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be2768d3f1d3a912e569e4dbaf407e4e7c881646275d2352d5d36e380568de05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f696fa4865ae44d9390086d69318c6ad51d2b3425d77df5b3d17f45857e9a48e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0faccde150115bfff166681b0f0fc22afeace6893f9f41972bfe7eb6026880bc"
    sha256 cellar: :any_skip_relocation, ventura:        "7f7c1ee72012d279f55cc50be333ad179c419e2d58b86035da5b24fb6a9070a3"
    sha256 cellar: :any_skip_relocation, monterey:       "f3a3ec4943787e4407d8b3c0d096739d71e0e15e90090121d74c3e0b590493ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cc4e91b1eb64ecebcc988f28b958dc3ca9801e0f6b4458233cb4ff12865747eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c449650a3358d7038e5b73831cc000ce0af1610c84abac26e506e5ff33e802"
  end

  def install
    system "make"
    bin.install "cpufetch"
    man1.install "cpufetch.1"
  end

  test do
    # This fails in our Docker container.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"].present? && OS.linux?

    ephemeral_arm = ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                    Hardware::CPU.arm? &&
                    OS.mac? &&
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
    arch = (OS.mac? && Hardware::CPU.arm?) ? "ARM" : "x86 / x86_64"
    expected = "cpufetch v#{version} (#{system_name} #{arch} build)"

    assert_match expected, actual
  end
end
