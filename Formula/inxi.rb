class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.25-1.tar.gz"
  sha256 "17176e70516adae4adced317905ab759316e5658a55c4a002c130bbcc21af3b7"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd53d3c8d6d138729d6933f7c7b624a9dcb29f01a6d8366a5bb56d4b1438b5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "613e89fd2de652e3ed7098eb50c5f14d33a181f261fec817efbe89e94b900bf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "605abd0f8b543334c90d3ce8a352b3857dbd05e27435cfcc53cff2b4006db349"
    sha256 cellar: :any_skip_relocation, ventura:        "3306d6e23400dcb724ff29fc8918467575836daba7d16e37baeb72c27bcf3a6c"
    sha256 cellar: :any_skip_relocation, monterey:       "5e68b9926e7762b36b6f62988ffec72d8ad7cc57a5d75f2edcc69fc6706b9a49"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3d6a4e4cb4f389845a18ae68e08d627bcf4d4686be3e09713f5eeab680ac636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5973d5b3c64eeb61c3ed12fb8b362e73183a43d8c18c534b3a8b3613158360ce"
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
