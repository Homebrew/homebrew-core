class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.13.zip"
  sha256 "41e1a15dcb0afd7d4fa97e28dee2860b86936fa8a07b4db0fc13e7b483768632"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install "igv.sh", Dir["*.jar"]
    (bin/"igv").write_env_script libexec/"igv.sh", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"script").write "exit"
    assert_match "Version", shell_output("#{bin}/igv -b script")
  end
end
