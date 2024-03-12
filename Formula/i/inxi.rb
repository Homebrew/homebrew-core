class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/refs/tags/3.3.31-2.tar.gz"
  sha256 "ff5d138392ac557e31ede6cf96d73d1b9f972f42f6529d47fec2c51184bff338"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "883ca553bb369a2cd94b41c37f0a4d27285dc88aa5b4960a63c65dd923b24d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "883ca553bb369a2cd94b41c37f0a4d27285dc88aa5b4960a63c65dd923b24d7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883ca553bb369a2cd94b41c37f0a4d27285dc88aa5b4960a63c65dd923b24d7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa5b035bdded12cdcbc97e097d2f5ab930c41486e8dba2d87d91eafaea7f58b0"
    sha256 cellar: :any_skip_relocation, ventura:        "aa5b035bdded12cdcbc97e097d2f5ab930c41486e8dba2d87d91eafaea7f58b0"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5b035bdded12cdcbc97e097d2f5ab930c41486e8dba2d87d91eafaea7f58b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "883ca553bb369a2cd94b41c37f0a4d27285dc88aa5b4960a63c65dd923b24d7a"
  end

  deprecate! date: "2024-03-11", because: :repo_archived

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
