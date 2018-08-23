class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/3.1.2/dita-ot-3.1.2.zip"
  sha256 "0f66f45cb6a3de2e2b7a463da15486b6c37c0d6b609052fcd517f19c0490e5e7"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat", "startcmd.*"]
    rm_rf "temp"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/dita"
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
