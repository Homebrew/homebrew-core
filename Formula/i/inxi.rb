class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.33-1.tar.gz"
  sha256 "c2d7ae8914f2810d4377999c24d3839fa9a757a6ace59ff57ab366873161d38c"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "883ca553bb369a2cd94b41c37f0a4d27285dc88aa5b4960a63c65dd923b24d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "883ca553bb369a2cd94b41c37f0a4d27285dc88aa5b4960a63c65dd923b24d7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883ca553bb369a2cd94b41c37f0a4d27285dc88aa5b4960a63c65dd923b24d7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa5b035bdded12cdcbc97e097d2f5ab930c41486e8dba2d87d91eafaea7f58b0"
    sha256 cellar: :any_skip_relocation, ventura:        "aa5b035bdded12cdcbc97e097d2f5ab930c41486e8dba2d87d91eafaea7f58b0"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5b035bdded12cdcbc97e097d2f5ab930c41486e8dba2d87d91eafaea7f58b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "883ca553bb369a2cd94b41c37f0a4d27285dc88aa5b4960a63c65dd923b24d7a"
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
