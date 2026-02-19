class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "7409fc0d084f1ab02540eacbc14f29f0f057c07c1a972cb82014814ffdb70f51"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51352d1c776b2d92482cdcc74696fc54c8e0f3c222af630df38bb64a0fe10a80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "419cab03f822d85528758f84e82e26568ad65e5d4015a2d3194c719d31c1b5cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a8d9aab2beb9a895956c8bb4c8a20558806eae0b8304cc52e7aa87dbc08737"
    sha256 cellar: :any_skip_relocation, sonoma:        "9972ea5fc26b8523c7b268ce26a32d962b599317e76b175c91eda165c51c3ec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecdcbb6d1f6b3b46077126785b88de2ecb8127cb7643de840a22fc1fd292109d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fed6d4b244498d6913aebfb69291bec94189d081a7ee22b446235a53567b6f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
