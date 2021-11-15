class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.08-1.tar.gz"
  sha256 "44008d9e77dc82855fd91d634f5f817813eb4653e4df7106e56a1c9986ab8abd"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3020e98c06282771e24069218af450f06a34be75e872de5ede0785f474881b2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3020e98c06282771e24069218af450f06a34be75e872de5ede0785f474881b2e"
    sha256 cellar: :any_skip_relocation, monterey:       "ead85103f91c94113b2970a4758f14bba35b5ec8508e0107268a38bee719c624"
    sha256 cellar: :any_skip_relocation, big_sur:        "ead85103f91c94113b2970a4758f14bba35b5ec8508e0107268a38bee719c624"
    sha256 cellar: :any_skip_relocation, catalina:       "ead85103f91c94113b2970a4758f14bba35b5ec8508e0107268a38bee719c624"
  end

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")

    uname = shell_output("uname").strip
    assert_match uname.to_str, inxi_output.to_s

    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
