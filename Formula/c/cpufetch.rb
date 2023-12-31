class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  url "https://github.com/Dr-Noob/cpufetch/archive/refs/tags/v1.04.tar.gz"
  sha256 "1505161fedd58d72b936f68b55dc9b027ef910454475c33e1061999496b30ff6"
  license "GPL-2.0-only"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a22a79f829c7dff316f9028a18910ca639d3934288316b096f746ea3f72c2dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde2572678e219669893fe29e3fa5a4737968812ad1dd5fb718c62a1d2a8bed8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87694dc7eb4cadec9819fbc300d7a7999544eea4c2e7074d7e246acf268c08b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b05a35d5cda56806832e88947600044307264463cdb5f12db13bd6c452918cd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "797940ee020487833c4d3fa58ea9bff419c98dbdb2bd7422d75a24846ba827e1"
    sha256 cellar: :any_skip_relocation, ventura:        "95ba5156edfbec49c499bfac6e6f8b0c370af7392b2c3b71ad33169cd637208e"
    sha256 cellar: :any_skip_relocation, monterey:       "4f2fc93b4f095d338247368c62ed66fa873c25eb8dfa8ec48faccb2e05550778"
    sha256 cellar: :any_skip_relocation, big_sur:        "616c55a170525a282583cc98be969b049242adef343241ee5b77db685c309dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2daa19537af4c766f00eb04d92d24e142581c635fc686a50662807771c6e88ef"
  end

  def install
    system "make"
    bin.install "cpufetch"
    man1.install "cpufetch.1"
  end

  test do
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
    arch = (OS.mac? && Hardware::CPU.arm?) ? "ARM" : Hardware::CPU.arch
    expected = "cpufetch v#{version} (#{system_name} #{arch} build)"

    assert_match expected, actual
  end
end
