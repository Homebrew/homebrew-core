class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "b5f7ea602c8f1c23a7109ebc89526fd1b8221e93d3c36093fd1c4e5f482f0f19"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7e221d78957e894d0d6373ac007a743ce396f475db449019d352b54bad285ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda0ba04c82b831aab9ccaffabd4f99503f9bbc29d0d42daf27c8180f64732ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dddd067aeaf96470900d2235fdbbde77456b86540f01b51e1580343f73a35cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2e4d5016e2925c5caa59a212efac8a967db2284a770a21a1574ca1f2eb35b4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee77712903516cf2b34a2d7136aa63464283931825aab1007facfbaa6d3cbe10"
    sha256 cellar: :any_skip_relocation, ventura:        "099a60f5081a83c16dfb0b496fe5a37e6dc9fb9dd7a7c12a36bcaee9ba8a3d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "77a4c5eed6ddee795bbee7aaee8a2492ae661fa1450bfacf1e821709ad90a870"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c26e628732a5240ecfb5591405da9777311778e251e53ee81347e3c46c583c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3a07a2465c8cdb645c2e4ae46a25bc0816e7ea33d3a258003b831940e0d681f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
