class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.3.0/pdftk-v3.3.0.tar.gz"
  sha256 "f8218de3bed18ca0d22337d1f3410b2a005794f8bb3729c8da20f3a49954c9ba"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84b25de48db162082d2b9f4339d718836ccaadc13197ec9a2e547758ff89da15"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f2b754be7be891f87d2252b774a845ea8b3d5564e1834eb1f8efdb2cfbf9aae"
    sha256 cellar: :any_skip_relocation, catalina:      "db5aed5d0bd12239d7a36b2f52ab6efccd6406a0c19839d33c7481abd18e3f51"
    sha256 cellar: :any_skip_relocation, mojave:        "6cb812b6d452482410f8d43e324cfc510d18fd088f6d1b65b02c15735145e81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ffbf90b113a1886b3a8051d9da69d8800bd0ea6e861de3a3c9f71df312d629"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@11"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", java_version: "11"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
