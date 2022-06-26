class Pla < Formula
  desc "Tool for building Gantt charts in PNG, EPS, PDF or SVG format"
  homepage "https://www.arpalert.org/pla.html"
  url "https://www.arpalert.org/src/pla-1.3.tar.gz"
  sha256 "a342bfe064257487c6f55e049301cc7d06c84b08390a38fd42c901e962fc4a89"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?pla[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f335f954b419f71258a566f1abee2db8211f21aee91bb98f1c97ea8d42e48761"
    sha256 cellar: :any, arm64_big_sur:  "2cf83294bbf3d2bd6679e81eb248c588a413ddeadac46ceb24de6affb368aa06"
    sha256 cellar: :any, monterey:       "0787de036e4a83bc03c2153ec4f447d187d6382c5bbf55f19cefb96488412b1a"
    sha256 cellar: :any, big_sur:        "a40094ed802100f73d1ba8fedf5e536649c7fcae1e8a1bed9e240abdc690f221"
    sha256 cellar: :any, catalina:       "9f16be821eecfd9fdc72071f1c2071790904f06ca56c0cf106021e7a1f4c8342"
    sha256 cellar: :any, mojave:         "f5199145d23f1b5c686958a7086b46ddbeb9e1b5041f456d94144cd4c7939821"
    sha256 cellar: :any, high_sierra:    "dd5b14bc8630dc3b16657e3e764b48cd9d851967daa1c7f039298bf4f2af7b78"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"

  def install
    system "make"
    bin.install "pla"
  end

  test do
    (testpath/"test.pla").write <<~EOS
      [4] REF0 Install des serveurs
        color #8cb6ce
        child 1
        child 2
        child 3

        [1] REF0 Install 1
          start 2010-04-08 01
          duration 24
          color #8cb6ce
          dep 2
          dep 6
    EOS
    system "#{bin}/pla", "-i", "#{testpath}/test.pla", "-o test"
  end
end
