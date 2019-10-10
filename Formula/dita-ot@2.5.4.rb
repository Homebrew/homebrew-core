class DitaOtAT254 < Formula
  desc "DITA Open Toolkit - implements OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/2.5.4/dita-ot-2.5.4.zip"
  sha256 "822c18768e8b78542e4420e98df86a415283ae1e1c9dd66937246cd65c0df34f"

  keg_only :versioned_formula
  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat", "config/env.bat", "startcmd.*"]
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/dita"
  end

  test do
    system bin/"dita", "--version"
  end
end
