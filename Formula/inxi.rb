class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.11-1.tar.gz"
  sha256 "424db24db457d3b87661f12fdc94e68a63e57ab4eb9982ccba2078451be79c59"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee4bd1d7d855a68b214f54b2329867c86dc9438305f487c7659614e2169a6c4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee4bd1d7d855a68b214f54b2329867c86dc9438305f487c7659614e2169a6c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "b81284918e2e159b895e0111e6f0593e61f7e4bbf2ed51fc37445227e6c5bbd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b81284918e2e159b895e0111e6f0593e61f7e4bbf2ed51fc37445227e6c5bbd8"
    sha256 cellar: :any_skip_relocation, catalina:       "b81284918e2e159b895e0111e6f0593e61f7e4bbf2ed51fc37445227e6c5bbd8"
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
