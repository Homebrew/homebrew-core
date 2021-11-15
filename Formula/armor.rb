class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.4.14.tar.gz"
  sha256 "bcaee0eaa1ef29ef439d5235b955516871c88d67c3ec5191e3421f65e364e4b8"
  license "MIT"
  head "https://github.com/labstack/armor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7d324f8f1434871982290e8ce54ddae0652d1d82f8bfd478d4af44ec4f9727"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99f1b988d091e6175983074889c2695625a0bcd3ee3df94bfbea09851906848b"
    sha256 cellar: :any_skip_relocation, monterey:       "26e58dd0953eca688f53bbbdc792d9b2457bc0369c3c7f8652da627430d8bc3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "06a9bcd5cee3c858cb616f2165ca3dfb0b9e6d5f9811297a260f909791ade865"
    sha256 cellar: :any_skip_relocation, catalina:       "d0bbf39148c0dabb28f777b951492814a708dc64610106587b1315fcd6a08559"
    sha256 cellar: :any_skip_relocation, mojave:         "538f2c340ec151aa7c22847a61d3c8e1d255d121a2b2a75fe2fe7d22f5067347"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8fc3b2ebb6d8bc978f6dd04c92e2a43573b052e51d69398deb4f5a2b04e0f87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506a0b09767c4cd594f3b4e3d2d46d04c36ff95d46f318911bf72d95e88e20ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "cmd/armor/main.go"
    prefix.install_metafiles
  end

  test do
    port = free_port
    fork do
      exec "#{bin}/armor --port #{port}"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}")
  end
end
