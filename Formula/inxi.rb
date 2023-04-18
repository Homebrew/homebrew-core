class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.26-1.tar.gz"
  sha256 "9c76b90044a5840d9e32fd83d1b3c1bb0d7c39c89904ac387cf6be339785451e"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2c3a71553184c31e281aeb766b6020d90bf7c1d8b7662d9ee8745e4ad2f04e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2c3a71553184c31e281aeb766b6020d90bf7c1d8b7662d9ee8745e4ad2f04e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2c3a71553184c31e281aeb766b6020d90bf7c1d8b7662d9ee8745e4ad2f04e6"
    sha256 cellar: :any_skip_relocation, ventura:        "69e620d7b897ca21c426cbdf59a8dce5c5b273c692a382eda1a22ce169fc8567"
    sha256 cellar: :any_skip_relocation, monterey:       "69e620d7b897ca21c426cbdf59a8dce5c5b273c692a382eda1a22ce169fc8567"
    sha256 cellar: :any_skip_relocation, big_sur:        "69e620d7b897ca21c426cbdf59a8dce5c5b273c692a382eda1a22ce169fc8567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2c3a71553184c31e281aeb766b6020d90bf7c1d8b7662d9ee8745e4ad2f04e6"
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
