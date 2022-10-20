class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.22-1.tar.gz"
  sha256 "718051fd275a03e9e488443ac73fe399e82c3be02745401672ae7567b150c6b5"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb8ae51171e21cd6b2501c91dbaec8139e8c48fc54e96b468549ce3705d3b7e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb8ae51171e21cd6b2501c91dbaec8139e8c48fc54e96b468549ce3705d3b7e9"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6c43d1bebe9e99c3cc111a343f5f333ff28c5f4228fc38edb8315ff5748ae7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc6c43d1bebe9e99c3cc111a343f5f333ff28c5f4228fc38edb8315ff5748ae7"
    sha256 cellar: :any_skip_relocation, catalina:       "cc6c43d1bebe9e99c3cc111a343f5f333ff28c5f4228fc38edb8315ff5748ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb8ae51171e21cd6b2501c91dbaec8139e8c48fc54e96b468549ce3705d3b7e9"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
