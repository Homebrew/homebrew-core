class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.34-6.12.4-1.tar.gz"
  version "6.34-6.12.4-1"
  sha256 "8cc1983c7bbed7f23fcf3cd549fe8dc10b1a506b95129c35e9f61d2e79b85295"
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
    # Disable parallel build until release with https://gitlab.com/DavidGriffith/inform6unix/-/commit/dab07d5c83a42e1c52e4058d6a31a8137f54b59c
    # ships; see https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
