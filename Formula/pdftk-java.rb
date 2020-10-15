class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.2.0/pdftk-v3.2.0.tar.gz"
  sha256 "f61f544ac139ee50ad177a51edede2ca259488d7435e37bf33b823bb2d43d626"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cd4ce772b1ae8cf8d9d67232f434f32439890e8810b3b5d54d59e3f65433486b" => :catalina
    sha256 "1efae8075702b2414b7cf5bc370b9b7d4a0370029e851783621cc679577eb7dc" => :mojave
    sha256 "cccf082754df1f34fdb8c3d684bdda3eea6fdc10175d496fa242040c858b5801" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on java: "1.8"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", java_version: "1.8"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
