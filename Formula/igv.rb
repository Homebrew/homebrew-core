class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.7.zip"
  sha256 "efeafd45e214060b7b0576f61cc12fc2166899aff5b9f7dc2de82cb80635b433"

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
