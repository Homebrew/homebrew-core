class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.88.tar.gz"
  sha256 "e0bfad4c7cf5d8a05305107ab53829a33b209446aaec515d5c51b72392b1eda7"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaba08da14a3266a7b60bcd232c24d121ba9aa1741e768f54e77fd09f6c67fcc" => :catalina
    sha256 "87a9b43c6ac20b2dc270cc35b1da0df4a92758bc722882407dcacbacb7e806d7" => :mojave
    sha256 "35be2be5fd71b1784b85a7bd5ba7ccf35f987fd6ed0548df7864cd686e28c5c0" => :high_sierra
    sha256 "9c78ad6dd2f3c02ef7ca508af88114f8deffa691cf3a546e6ca09ed279b80758" => :sierra
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
