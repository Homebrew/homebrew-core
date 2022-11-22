class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  url "https://github.com/Dr-Noob/cpufetch/archive/v1.02.tar.gz"
  sha256 "3d1c80aba3daa5fe300b6de6e06d9030f97b7be5210f8ea4110de733ea4373f8"
  license "GPL-2.0"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c607454509c0e6d3b292e36e3e47bc4b9e825ab68099a70e2ab672ef21b2a181"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e957f2ce010aaf62e12573c176a666ded448450af54c2b7b6acd4c25561cee2"
    sha256 cellar: :any_skip_relocation, ventura:        "a4c8cfa60f70dacf452afd5328e70430fed0f42731b835c97d765bf91e9dcd1d"
    sha256 cellar: :any_skip_relocation, monterey:       "fc8ccba3b0c22f4eeae582ef6467629390b4123f71cddc5bb2208e86409c37d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0364a04659759812076a6b70117e26679bbac74cee4943b7575844cb24169d16"
    sha256 cellar: :any_skip_relocation, catalina:       "fecfd3b7d1c1a4b9811ec886f5733b1ebe944a9ceab4a0526ff18702674c5591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22c8f22e55957d44ba4a34167bd8d64d3dd01c54ba61a36c4fba9191dc343064"
  end

  def install
    system "make"
    bin.install "cpufetch"
    man1.install "cpufetch.1"
  end

  test do
    actual = shell_output("#{bin}/cpufetch -d").each_line.first.strip

    expected = if OS.linux?
      "cpufetch v#{version} (Linux #{Hardware::CPU.arch} build)"
    elsif Hardware::CPU.arm?
      "cpufetch v#{version} (macOS ARM build)"
    else
      "cpufetch is computing APIC IDs, please wait..."
    end

    assert_equal expected, actual
  end
end
