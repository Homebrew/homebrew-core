class Httpry < Formula
  desc "Packet sniffer for displaying and logging HTTP traffic"
  homepage "https://github.com/jbittel/httpry"
  url "https://github.com/jbittel/httpry/archive/httpry-0.1.8.tar.gz"
  sha256 "b3bcbec3fc6b72342022e940de184729d9cdecb30aa754a2c994073447468cf0"
  license "GPL-2.0"
  head "https://github.com/jbittel/httpry.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b7bf13b5cb242152bddbdd26ffc2d3102849a0ff8c95f5b7fac5ee818cd0ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96df271f206bb36741a419eb5dced955578cb462c849da52e61778102f8629d2"
    sha256 cellar: :any_skip_relocation, monterey:       "31a42f2ee46af90cf63b5da4cf20066a8a35cb4f977794e94e1179bd2df01169"
    sha256 cellar: :any_skip_relocation, big_sur:        "4be4a4e9939e75e8eb4854df6003265f986ada5b2d08ba96fbaf355323f184f2"
    sha256 cellar: :any_skip_relocation, catalina:       "322f399002eec5d9116942db65d231d7eed5bb1b46e9959cdb48c6eb10f41339"
    sha256 cellar: :any_skip_relocation, mojave:         "32bdf2c6b873fc531455da9f4658746c650203a017c8b367172efde8aa93f9ba"
    sha256 cellar: :any_skip_relocation, high_sierra:    "349ba4f39066cb02c151ab0f274f6bb9f4ee2cf558abdb2c5a3ecf0e563874fc"
    sha256 cellar: :any_skip_relocation, sierra:         "71014794d2a136fea229dd19d6fe7dc136037c074a817d70bd7b13713653f19f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "56d6a77e429bf9dde3d5e5edb9959fc7ed913430236cf628e0aec6445c07c85a"
    sha256 cellar: :any_skip_relocation, yosemite:       "af0deb9d79e72df6369f57ed1050abeb70c62f77ab481232b556ba6da5ace66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "362c2d3249eec72e7baebdde1a8c0a2e6a2b005e70b516733b96fa01e2aaf55e"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    bin.install "httpry"
    man1.install "httpry.1"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"httpry", "-h"
  end
end
