class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r2.tar.gz"
  version "6.35-r2"
  sha256 "5b08987ec4fd1b06f3c0769c7fa13607a7387ff9f901ed375916846b4217582c"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "045dd5e16b6eb02c202d366860e7aaabc0a3af6a934fd061ac7fed5177fe31a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "9786ae0a2fe967eb5c016b11f7c7820ad10368028fd3adcbb580f8cb16e48350"
    sha256 cellar: :any_skip_relocation, catalina:      "93637b51aab07fd75de01b2e95d128bc56993ef99333df1183ffa14b5ab80961"
    sha256 cellar: :any_skip_relocation, mojave:        "c8f2f9c75d25a79e0e3a379fcda5768724f2ea8eb328c1b083f49bdd5b11045b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "376492f4b617b4efcd3c6bc8ee154dbedf13284649c989410339ce0cc0cce663"
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
