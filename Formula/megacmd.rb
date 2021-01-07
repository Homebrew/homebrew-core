class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.016.tar.gz"
  sha256 "def4cda692860c85529c8de9b0bdb8624a30f57d265f7e70994fc212e5da7e40"
  license "MIT"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "768dd63394ec073bc604441dc4a9659d0e3c004cc7dd28564cb43aa6509d64b8" => :big_sur
    sha256 "dbdf31cf520acdbd26abf2d5876b992b910bfa19f3d91b69638050bb07077a3e" => :arm64_big_sur
    sha256 "80a5775ff5e5fe1e958cc6345a2d53f13e37bf366c7f4c8f3033f218851de813" => :catalina
    sha256 "e7612192a4ac2e79363d8441f7d0f007c319a5aafd8e4f56e805335cbfa72d21" => :mojave
    sha256 "02e75c7bbada7c3b3a230f3395448ec1dfb8598e7053ac6ad6a2b0b2f264d9ad" => :high_sierra
    sha256 "8f60fb2783c1481f086e401e7cbfb2ada3a6e82a35e6d2e1a24643a7c7d8453f" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    system bin/"megacmd", "--version"
  end
end
