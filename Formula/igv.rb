class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.14.zip"
  sha256 "0c6e466736ac08b2aba28f1ffa4c9f136b3948dcbb61b04a89afcdcf0298307d"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install "igv.sh", "lib"
    (bin/"igv").write_env_script libexec/"igv.sh", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"script").write "exit"
    assert_match "Version", shell_output("#{bin}/igv -b script")
  end
end
