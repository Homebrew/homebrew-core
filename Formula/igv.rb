class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.16.zip"
  sha256 "c1d6bc149876cc3e89dbde5ed8c2f2329a661ead30c0a6ba09fce9c33f10542f"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install "igv.sh", "lib"
    (bin/"igv").write_env_script libexec/"igv.sh", Language::Java.java_home_env("1.8")
  end

  test do
    assert_match "org/broad/igv/ui/IGV.class", shell_output("jar tf #{libexec}/lib/igv.jar")
    # Fails on Jenkins with Unhandled exception: java.awt.HeadlessException
    unless ENV["CI"]
      (testpath/"script").write "exit"
      assert_match "Version", shell_output("#{bin}/igv -b script")
    end
  end
end
