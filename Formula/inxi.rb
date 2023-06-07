class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.27-1.tar.gz"
  sha256 "35207195579261ddfe59508fdc92d40902c91230084d2b98b4541a6f4c682f63"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f8993a1dc690aca92d21a9d946d910ea20a4afba9a772a01649de8f160ca48e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8993a1dc690aca92d21a9d946d910ea20a4afba9a772a01649de8f160ca48e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f8993a1dc690aca92d21a9d946d910ea20a4afba9a772a01649de8f160ca48e"
    sha256 cellar: :any_skip_relocation, ventura:        "7a5774623de663e1045c93478547eaa96f141ab20ce82a3d164877b4d342bdc8"
    sha256 cellar: :any_skip_relocation, monterey:       "7a5774623de663e1045c93478547eaa96f141ab20ce82a3d164877b4d342bdc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a5774623de663e1045c93478547eaa96f141ab20ce82a3d164877b4d342bdc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f8993a1dc690aca92d21a9d946d910ea20a4afba9a772a01649de8f160ca48e"
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
