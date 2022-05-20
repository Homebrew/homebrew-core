class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.3.2/pdftk-v3.3.2.tar.gz"
  sha256 "23bd8ff9a9c021c9bcd87e0d4eb3359ecdb12bef6879062e8d9bb25e18cb67df"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48ed05a44116056bfa719f0c05b8ad15fed3d149c6d38a95040a3c0494c93028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "358a5e0e9594cb02df4275c16f8775ecded3bf2823a15564372491e407ae80fd"
    sha256 cellar: :any_skip_relocation, monterey:       "26e14850fc1c1e24ae7d52492d8cb07e0dd5273b246edc329d84b915da3b9ca0"
    sha256 cellar: :any_skip_relocation, big_sur:        "91eed73d4a0f66b24a36d70c79901fa1691546580c47d6dbbde24d3d18ac882a"
    sha256 cellar: :any_skip_relocation, catalina:       "4d5f5f28dcab3b1db472272038c9613031c73b528ac9b4ac27fca2a6c678f4b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67921a471c816007935efe800e90321318ff1c6f78d5b031ed84b866490c89f5"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@11"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", java_version: "11"
    man1.install "pdftk.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
