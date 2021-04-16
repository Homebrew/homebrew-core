class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "http://libslack.org/daemon/"
  url "http://libslack.org/daemon/download/daemon-0.6.4.tar.gz"
  sha256 "c4b9ea4aa74d55ea618c34f1e02c080ddf368549037cb239ee60c83191035ca1"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a634d876fc4382b34bfd5f3b564a62a251e3eb3b6d07ab03a9c27f25617c44f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d16b2615f5df9838e2d75351fae720910beae254d62f0970b64cddedeb289b8"
    sha256 cellar: :any_skip_relocation, catalina:      "8cc2278936a35f9ae2c0952e4be5c9e06970386f3c9c5ae528b18c69902e9220"
    sha256 cellar: :any_skip_relocation, mojave:        "0fd225e226dd07c3f51836f47bf9829dd095a46a13a5b78c3a0e9df3c5820683"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ca2b1016c1bbe48002f70b7beb86063943dadabcb670db9f90f1c259cb34d623"
    sha256 cellar: :any_skip_relocation, sierra:        "bfc116e8f0853cdf5b4abc38b1f000c90708823bf49c5237f8ec453400a5d606"
    sha256 cellar: :any_skip_relocation, el_capitan:    "ad4f8ad9e7deeb0039c6c603b0108fb6733abe425c49fa6344f762e26b49cf2d"
    sha256 cellar: :any_skip_relocation, yosemite:      "f48000af3631f28d47d01d3d89a1f03e7c4f7eac4a81ab7db9c38a1ce9ff66cd"
  end

  # fixes for strlcpy/strlcat: https://trac.macports.org/ticket/42845
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3323958/daemon/daemon-0.6.4-ignore-strlcpy-strlcat.patch"
    sha256 "a56e16b0801a13045d388ce7e755b2b4e40288c3731ce0f92ea879d0871782c0"
  end

  def install
    # Parallel build failure reported to raf@raf.org 27th Feb 2016
    ENV.deparallelize

    system "./config"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
