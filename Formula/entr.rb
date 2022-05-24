class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.2.tar.gz"
  sha256 "237e309d46b075210c0e4cb789bfd0c9c777eddf6cb30341c3fe3dbcc658c380"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "270d91dfcd9338451893d293cec6d3a678b60b992b11f4e4c3abc38b759cf6f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05029ebc446156661c5dfbfcca580b5d86eabf6a2ebef2aa3588fc8b0e7a6f2e"
    sha256 cellar: :any_skip_relocation, monterey:       "1bc645365005cf6436d910ba5274d145637fe96d2c1c2c1879c19a92c8f9e8ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecb46fcc12d0660c98fb34ea7499400f28fce37bc732fddf8b41280bb3fe911d"
    sha256 cellar: :any_skip_relocation, catalina:       "eb8cdfa72ff30ef75df060cc5ea0e10f0b2225be92cffcdd365731d576dbba8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e1f28408eb01df7f7421e5cc723f9bd998c8f3def0af26dcad45a86647c53c"
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
