class Briss < Formula
  desc "Crop PDF files"
  homepage "https://briss.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/briss/release%200.9/briss-0.9.tar.gz"
  sha256 "45dd668a9ceb9cd59529a9fefe422a002ee1554a61be07e6fc8b3baf33d733d9"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95064b9aa616b6f63cd7f5746cec3865a0441c070aed78716868cbd5aa500ab9"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*.jar"]
    bin.write_jar_script libexec/"briss-#{version}.jar", "briss"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system "#{bin}/briss", "-s", "test.pdf", "-d", "output.pdf"
    assert_predicate testpath/"output.pdf", :exist?
  end
end
