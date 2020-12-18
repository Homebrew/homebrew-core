class PictaDl < Formula
  version "2020.12.14"
  desc "Download videos from Picta.cu Plataforma de Contenidos Audiovisuales"
  homepage "https://github.com/oleksis/picta-dl/"
  url "https://github.com/oleksis/picta-dl/archive/v#{version}.zip"
  license "Unlicense"
  sha256 ""
  
  depends_on "python@3.9"
    
  def install
    libexec.install Dir['*']
    system "echo \"python #{libexec}/picta-dl \\$@\"> #{libexec}/picta-dl.run "
    bin.install_symlink "#{libexec}/picta-dl.run" => "picta-dl"
    libexec.install_symlink "#{libexec}/picta_dl/__main__.py" => "picta-dl"
    system "chmod +x #{bin}/picta-dl"
  end
  
  test do
    assert_match version, shell_output("picta-dl")
  end
end
