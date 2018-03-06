class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.9.zip"
  sha256 "e18dd8372e34454ac51cf3fb846fa26f22c34e12e1c6c4aaf9573c01ccc19e29"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install "igv.sh", Dir["*.jar"]
    bin.install_symlink libexec/"igv.sh" => "igv"
  end

  test do
    (testpath/"script").write "exit"
    assert_match "Version", shell_output("#{bin}/igv -b script")
  end
end
