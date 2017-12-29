class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.5.zip"
  sha256 "89c8095f4be174a396aa0e509aec592f1ae3a1c8f3c7be0d0fc047d4c35fe17a"

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
