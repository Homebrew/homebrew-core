class AntlrAT3 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr3.org/"
  url "https://www.antlr3.org/download/antlr-3.5.2-complete.jar"
  sha256 "26ca659f47d77384f518cf2b6463892fcd4f0b0d4d8c0de2addf697e63e7326b"

  keg_only :versioned_formula
  depends_on :java => "1.5+"

  def install
    share.install "antlr-3.5.2-complete.jar"
    (share+"java").install_symlink "#{share}/antlr-3.5.2-complete.jar" => "antlr-3.jar"

    (bin+"antlr-3.5.2").write <<~EOS
      #!/bin/sh
      java -jar #{share}/java/antlr-3.jar "$@"
    EOS

    bin.install_symlink bin/"antlr-3.5.2" => "antlr3"
  end

  test do
    assert_match "ANTLR Parser Generator  Version #{version}",
      shell_output("#{bin}/antlr3 -version 2>&1")
  end
end
