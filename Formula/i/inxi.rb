class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.34-1.tar.gz"
  sha256 "7cfc5c0abe10cb59f281733ce1d526583312344007756e7713fd5c51200b80fb"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f4e1fc09d743cb305b8a1036c8c52368fdab78ea293938d4a555fa5d9bb9635"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f4e1fc09d743cb305b8a1036c8c52368fdab78ea293938d4a555fa5d9bb9635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f4e1fc09d743cb305b8a1036c8c52368fdab78ea293938d4a555fa5d9bb9635"
    sha256 cellar: :any_skip_relocation, sonoma:         "fecbb86a8ad7b79c3579e3a70e9bac1c0ec7556c7d398a3f122b1d1290753ba5"
    sha256 cellar: :any_skip_relocation, ventura:        "fecbb86a8ad7b79c3579e3a70e9bac1c0ec7556c7d398a3f122b1d1290753ba5"
    sha256 cellar: :any_skip_relocation, monterey:       "fecbb86a8ad7b79c3579e3a70e9bac1c0ec7556c7d398a3f122b1d1290753ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4e1fc09d743cb305b8a1036c8c52368fdab78ea293938d4a555fa5d9bb9635"
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
