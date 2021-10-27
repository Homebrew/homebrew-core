class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.0.tar.gz"
  sha256 "2a87bb7d9e5e89b6f614495937b557dbb8144ea53d0c1fa1812388982cd41ebb"
  license "ISC"
  head "https://github.com/eradman/entr.git"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dc317acdee0ef50e4c2e99b64bed46b457d3447363e5af9879b7eaf1d4bded3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f16eedf5935042476d987e023d856cf2600b88c591cc175c3b8d84c3d5f5a99"
    sha256 cellar: :any_skip_relocation, monterey:       "79fb330b6af374901d14a9f9dc7ceb320f77fb097d80be9e51a0ca0f64596405"
    sha256 cellar: :any_skip_relocation, big_sur:        "34c0d604196544f8ae2e42b12aa74f00629cac3f5bfb98afc129fed8d67b2098"
    sha256 cellar: :any_skip_relocation, catalina:       "d8da9de096d0a21583ca63bc426b0880ad873b89d003beac8e99d5208b58daa1"
    sha256 cellar: :any_skip_relocation, mojave:         "a892e39fd5faed448d1cca2fcee8a961dda60cb8bb811f63f5ed3773e1e84b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d9d924c7e75e1ff0f336820541204b543a023e85c49f3388536b4aa0e70334"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath).strip
  end
end
