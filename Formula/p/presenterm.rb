class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7514566a58715967617c681a9222d3d84ba03c15b002adab2ac8775d34ddc575"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "699d6b4c9a807e0e39c5a95c5595bed0cd0db11ffeb4762d2dd6e986d485a143"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe672d3974b166097a7c3de9aa1f05b57b35321d2a93cb4923937ea36f33736"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea869ee5dad8a352827a49322b48877705f71e6a28d401451cc205331d29f6bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "6111b37a97c4d42e3e00ccda98ec220b87a32e3b3ac46533bef6d52a0a0e9bb9"
    sha256 cellar: :any_skip_relocation, ventura:        "82b09f03c2f420cda9cd0452d14e23eea371f5817da065cc9dccf10811448073"
    sha256 cellar: :any_skip_relocation, monterey:       "19ca66da58f7bcd6545e7396599e80605e0584cc388b329ba2469174951b17de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482d0a8058626e3a407dd2d02d7b810ad952b06a8774a9d6a426bfadf9bbe706"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/presenterm non_exist.md 2>&1", 1)
    assert_match "reading presentation: No such file or directory", output

    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
