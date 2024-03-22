class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20240111.tgz"
  sha256 "b9c630296d767c2bdfc98aa6f4ecd9157b70becad713ce9e4ce99a42d4785aaa"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ee113bb71ff30604528082148d6fe53a44adc7ddf12b727ce05af567196a374"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b69058a8efe36e5e3208e21fc10a5d46c614f232023588069eae9050d5c584e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a91761cc59a46927a0607b28239166fa0ffff5bbe170792af5881fb028007511"
    sha256 cellar: :any_skip_relocation, sonoma:         "a02b82e0cbb862d8601831e06ba0fa62275fb8ac341bc900199d9f79d717685a"
    sha256 cellar: :any_skip_relocation, ventura:        "478159577571793e9b0f7c12e112c7219f67a635395f5155df3123532653adc8"
    sha256 cellar: :any_skip_relocation, monterey:       "f8e77cb73aee04f94fea94f2e5c4ec07db422f8f4818ab9bba327d2d95a35779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f15166608a8b8763036b85d7c0803b2aa003a09855fb5b20ac002b21c37bb60"
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
