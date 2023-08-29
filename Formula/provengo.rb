class Provengo < Formula
  desc "Model-based testing and automation system"
  homepage "https://provengo.tech/"
  url "https://downloads.provengo.tech/installer/provengo-0.7.5.zip"
  sha256 "f632d7c59ef0e2aaddb223c59906bd776acf30450167e384db486d48c99f5f5b"
  license :cannot_represent

  depends_on "graphviz"
  depends_on "openjdk@11"

  def install
    inreplace "provengo", "%CELLAR%", "#{HOMEBREW_PREFIX}/Cellar"
    inreplace "provengo", "%PREFIX%", prefix.to_s
    prefix.install "Provengo-2023-07-20.uber.jar"
    bin.install "provengo"
  end

  test do
    shell_output "#{bin}/provengo --batch create #{testpath}/test"
    assert_predicate testpath/"test", :exist?
  end
end
