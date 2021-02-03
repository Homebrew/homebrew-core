class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.88.tar.gz"
  sha256 "e0bfad4c7cf5d8a05305107ab53829a33b209446aaec515d5c51b72392b1eda7"
  license "GPL-2.0"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "d728849547605c278baea4db869d73a585f79504923b0456819155f1b15a739d"
    sha256 cellar: :any_skip_relocation, catalina:    "aaba08da14a3266a7b60bcd232c24d121ba9aa1741e768f54e77fd09f6c67fcc"
    sha256 cellar: :any_skip_relocation, mojave:      "87a9b43c6ac20b2dc270cc35b1da0df4a92758bc722882407dcacbacb7e806d7"
    sha256 cellar: :any_skip_relocation, high_sierra: "35be2be5fd71b1784b85a7bd5ba7ccf35f987fd6ed0548df7864cd686e28c5c0"
    sha256 cellar: :any_skip_relocation, sierra:      "9c78ad6dd2f3c02ef7ca508af88114f8deffa691cf3a546e6ca09ed279b80758"
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
