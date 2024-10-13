class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.36-1.tar.gz"
  sha256 "0f1e0ac7d5b702e66aec8fc3c07aaba036c0d47e729c35f26f19cddaa0b234d2"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aaf65fcde3b31171790eeae118d5a88a6432b458715fac5fac9d6c6a358c3df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaf65fcde3b31171790eeae118d5a88a6432b458715fac5fac9d6c6a358c3df8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaf65fcde3b31171790eeae118d5a88a6432b458715fac5fac9d6c6a358c3df8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf65fcde3b31171790eeae118d5a88a6432b458715fac5fac9d6c6a358c3df8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f78973546615a80aa8a390afecf3f81bbe962a5e618badd8867944eb5d457015"
    sha256 cellar: :any_skip_relocation, ventura:        "f78973546615a80aa8a390afecf3f81bbe962a5e618badd8867944eb5d457015"
    sha256 cellar: :any_skip_relocation, monterey:       "f78973546615a80aa8a390afecf3f81bbe962a5e618badd8867944eb5d457015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf65fcde3b31171790eeae118d5a88a6432b458715fac5fac9d6c6a358c3df8"
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
