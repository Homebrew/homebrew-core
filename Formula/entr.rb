class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.3.tar.gz"
  sha256 "d70b44a23136b87c89bb0079452121e6afdecf6b8f4178c19f2caac3dec3662f"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19e77c22fc2cbba622e413ee7387441a195b9a9dbfdf4a8c369ab4f88c01b327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbbfa6225852f7c6cb81b4b343e9bdd34a525810d98e3084609c886bede81e32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b049f02ff567c13380eb718e5fe3f20ebd41d133aaadd18f2b8a49bab9d27c01"
    sha256 cellar: :any_skip_relocation, ventura:        "26a897bfd70b1fde256e888e1ac94674a0445bb671a2c126433fb05c9bd6dee2"
    sha256 cellar: :any_skip_relocation, monterey:       "8c63dc22fb95ccd6a3794c904f937336dedc08d3b41ed5f94555149f997ed9a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fefecd79d23b0bb05a5c02672a288c3b733062cbd2e5b53ab0864c01ec07ace5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffdaa2e01c945bc07b7be5f924ac75be7cfa917bb0f8969ca2e892329b6d26f8"
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
