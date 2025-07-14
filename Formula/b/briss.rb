class Briss < Formula
  desc "Crop PDF files"
  homepage "https://briss.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/briss/release%200.9/briss-0.9.tar.gz"
  sha256 "45dd668a9ceb9cd59529a9fefe422a002ee1554a61be07e6fc8b3baf33d733d9"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "3aa9a79afde1e2530551aa220ea217676898bc939ac9341574079e126f4eaa83"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*.jar"]
    bin.write_jar_script libexec/"briss-#{version}.jar", "briss"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"briss", "-s", "test.pdf", "-d", "output.pdf"
    assert_path_exists testpath/"output.pdf"
  end
end
