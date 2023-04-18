class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.12.tar.gz"
  sha256 "5b4fb14d38314e09f2fc8a1c510e7cd540a3ea0e3eb9b0420046b82c3bf41085"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fadc95890650691a397cf0d5bb076cd8828b4773f7b33bac9005b62e983baa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17d882a783a96c603e4960caceab2d5ea2d2e838d9eee516652d388d23be33b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f20559cd8d35e9db646d3d7ff5c56e3d07352ae1fd2f1463de778b0609cb49ae"
    sha256 cellar: :any_skip_relocation, ventura:        "30996f026156d5446b32d92074b5059084ee26dbbb7c2bd3dcd4706af3d4b3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf75c712f706f499314df85c82a0e386eac45f7770144a6ed3736955a8d21c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfcd96abd7479f2071b49d6d381ed08934c27f5b1b2b13d7627adaa85e350ec2"
    sha256 cellar: :any_skip_relocation, catalina:       "d29972e532493ff47adbb064b0a5c54b893ef2ae8c7d6b2f4edc104a4f203014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0112fa3e595f2f5e7b95c939aba21ddaeca8e710138e9c7d1258442c8ad758aa"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/gzip", "foo"
    system "#{bin}/gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
