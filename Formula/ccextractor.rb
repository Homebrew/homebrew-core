class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.86.tar.gz"
  sha256 "0c24b00384244a2e58d63ad2ef1cb69b2e0824c7461f707d40e926d49136330a"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d8eb30c2dab242fbcfa7abf1ae43632c4f900fc3a6c47dc9d08b6e845b71c6c" => :mojave
    sha256 "2c858d6d141433acae780b63cca1f005a0d4ae4f195acc0e4171fa4c9ff5e850" => :high_sierra
    sha256 "bde93a39dc5fc8fff9a731d90b5b2b5fc733eccdc8c7508ae8f7d109f58c96e7" => :sierra
    sha256 "fd15475973f2b22a24568f22a44937fbfedecf977089ebb86a1ec63aee2636a4" => :el_capitan
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
