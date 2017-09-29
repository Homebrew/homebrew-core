class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.4.zip"
  sha256 "a13047b642ad9a09f4a1641e3c99f2785599a3681d93740f67c71d770eb5e62d"
  revision 1

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install "igv.sh", Dir["*.jar"]
    libexec.install_symlink "igv.sh" => "igv"
  end

  test do
    (testpath/"script").write "exit"
    assert_match "Version", `#{libexec}/igv -b script`
  end
end
