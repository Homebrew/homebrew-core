class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r2.tar.gz"
  version "6.35-r2"
  sha256 "5b08987ec4fd1b06f3c0769c7fa13607a7387ff9f901ed375916846b4217582c"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c596c279a29befbca82053e12594b6ab3524c205f969b4747bc9e8ae6a8f1cf4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4b3d047e0686c3104ce51b8780b12202c6c3b9486ce3e386e1ac5e7acbe8944"
    sha256 cellar: :any_skip_relocation, catalina:      "4fa26f001f5e273bca4b561f2e7c3783d55fb7ab69f3bb098f109f72a789cc95"
    sha256 cellar: :any_skip_relocation, mojave:        "0c0de1e012507b4450e610d93e25497f13fef4c11f5d47dfdcd76cf7755f2c46"
  end

  resource "Adventureland.inf" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails at:
    # install -d -m 755 /usr/local/Cellar/inform6/6.35-r2/share/inform/punyinform/documentation
    # install: /usr/local/Cellar/inform6/6.35-r2/bin/punyinform.sh: Not a directory
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
