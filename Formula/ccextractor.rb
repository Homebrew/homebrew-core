class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.85/ccextractor-src-nowin.0.85.zip"
  sha256 "2ac21c6483e206a796d26d6adb7e969eb038a97ead9e2b2a7ee91b8b08c6882e"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35b445f24dd0be2979fb9cdb47eda8c45489aaa746d6efeb866a1e8d2329a272" => :high_sierra
    sha256 "708daa50fd6cd54bac11b8bb8f55b54b0999b180313538fa7bc3c346b4240c2e" => :sierra
    sha256 "c9b725b4f4680f534e6924fe0b2b68aa77b25ff14a4118d49bc60bdfaa286287" => :el_capitan
    sha256 "03f774c0122cad214d35afe8fbfdb450ca1713601858b07d783c8ade9757c44e" => :yosemite
  end

  def install
    cd "mac" do
      system "./build.command"
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    touch testpath/"test"
    pid = fork do
      exec bin/"ccextractor", testpath/"test"
    end
    Process.wait(pid)
    assert_predicate testpath/"test.srt", :exist?
  end
end
