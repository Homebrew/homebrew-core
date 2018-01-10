class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.6.zip"
  sha256 "ca4e28620d091f3387bfef0e8b22a3301fa919eb6dd084c3a8df6a631dece902"

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
