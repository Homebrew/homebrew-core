class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.18.zip"
  sha256 "a34e5155b2f162afaa977be17f9241c4d5be2140bf93fa71f205338f2c2cf641"

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
