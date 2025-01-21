class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.37-1.tar.gz"
  sha256 "da730f84f4a2ca53bab471860a83995c9d498bb34c2518fbb7ff65ee705e048e"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0dc059e9f7ab886820bc7fb3a5c94d4fd60413a12ffbc057a0016f763c51efb"
    sha256 cellar: :any_skip_relocation, ventura:       "e0dc059e9f7ab886820bc7fb3a5c94d4fd60413a12ffbc057a0016f763c51efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
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
    inxi_output = shell_output(bin/"inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
