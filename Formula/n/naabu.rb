class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.6.tar.gz"
  sha256 "4ac5cad16fa6e777bdf05c117d4bdc8e4ee82333277844be0d1a6083e29bf12a"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b64347a6ede7e4ef326ab1f69e3a3d111f5f0ddc35ee2873739de2eec26b6e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90ffd85c88538d73ac1733217180d00b76d721c49887b537aa8b9b4e6719f07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c75de8a01938c6839f3211bebedbc644fa9fa34934554f7fa9640418cf7b4a1"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e9b5f0516820d8e11284e5d09daab4005ad56bc64e33cccb9c35bada7b6e56"
    sha256 cellar: :any_skip_relocation, monterey:       "239e5e468136fb2d61ed8ff27e046b06620ab427d697f7fce2aec29031a09066"
    sha256 cellar: :any_skip_relocation, big_sur:        "669d73c37a32a6be6b7fcadb64fa1651117306d0c0497a1efa9061a8cecd1938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ac16dfaaf9e4a319cfcfa2fa241e698f798f3d11a732025233ebbe2921ab54"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
