class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.10.2.tar.gz"
  sha256 "62ce7ecad18b09970048537fc62be2ad75e1936d57710b3058c9c8a866675aae"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6d397938206bdc5b5db0106e9cff7de75e0220035ac704729e6b9af676edd9d" => :catalina
    sha256 "70801555e212940e2dff9619a1df446a0b2b0b45a57f401d62a4b878b7102108" => :mojave
    sha256 "2187d4d3e865b8a24eb03c7c4c893d48e020791f2901bbc4782344f01647307f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
