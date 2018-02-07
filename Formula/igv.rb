class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.8.zip"
  sha256 "18acc8410085308b169c4442274848ed7e285196c8bfd0b43100005996a644b1"
  revision 1

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install "igv.sh", Dir["*.jar"]
    bin.install_symlink libexec/"igv.sh" => "igv"
  end

  test do
    (testpath/"script").write "exit"
    assert_match "Version", `#{bin}/igv -b script`
  end
end
