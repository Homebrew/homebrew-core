class Nomore403 < Formula
  desc "Tool to bypass 403/40X response codes"
  homepage "https://github.com/devploit/nomore403"
  url "https://github.com/devploit/nomore403/archive/refs/tags/1.0.2.tar.gz"
  sha256 "1fda89e455b1372e718a6028e9576cd8cc5206524897b7a63c5fbe0448832cdf"
  license "MIT"
  head "https://github.com/devploit/nomore403.git", branch: "main"

  bottle do
    root_url "https://github.com/Neved4/homebrew-tap/releases/download/nomore403-1.0.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f531e4aa74e4aef01d6d8590fdd980a40941e3626a53724d7787e1719f7cae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cb0d3400079bcaabcab5577d500c01d468b8abc29ed45511d0cd36ddcde9858"
    sha256 cellar: :any_skip_relocation, ventura:       "3217d2cc676f516c9af3d0cd0053d551e6d544e44f58ff8973f3d05082386a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6a53f82679ffcccc9fe661ec52d35c36920ad98da781843eefec7e1ef32a7c"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      *std_go_args(ldflags: "-w -s"), "-gcflags=all=-l -B -wb=false"
    doc.install "README.md"
  end
end
