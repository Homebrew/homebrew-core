class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.3.3/pdftk-v3.3.3.tar.gz"
  sha256 "9c947de54658539e3a136e39f9c38ece1cf2893d143abb7f5bf3a2e3e005b286"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "626014736051e1e9c87441f86117b4b0edd3b5ae4ad8be645085b91447873085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed2ffccfc3600cd148a6795445902000b1131ab4aca7a2e8d6a989d8b00aeb64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b97d535fab834a2bacf655d15869af91b05d1a88c6dc63039b29669e45cc63a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "086851972845bf87aec1535dc4d9a1f6addd1311f468c926cbe7c6ab79e3f015"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a8f707c529d2f6a036448b5c5c864f5208b68403afb5aca2ae94052cb96b82b"
    sha256 cellar: :any_skip_relocation, ventura:       "a98dbbff8f1aa546bdffaee0f07b3cabb67ee74052cdbd5c03c1b720f047abbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc976b8e0b2bea3916feab4a2d5d5c88133cacd10e71350ba5804d0536c193c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b00258f2f947e48b44b821179d569babbe5d0ad5ffa2728f7e56085cfccc4f"
  end

  # Issue ref: https://gitlab.com/pdftk-java/pdftk/-/issues/182
  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk"
    man1.install "pdftk.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
