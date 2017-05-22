class BurpSuiteFreeEdition < Formula
  desc "provides a platform for security testing of web apps"
  homepage "https://portswigger.net/burp/"
  url "https://portswigger.net/Burp/Releases/Download?productId=100&version=1.7.10&type=Jar", :using => :nounzip
  version "1.7.10"
  sha256 "9f609d14d474f43c9261c920c4a868278cbac119fcee62a328274e093738378d"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install "Download"

    mv libexec/"Download", libexec/"burpsuite_free_v#{version}.jar"

    bin.write_jar_script libexec/"burpsuite_free_v#{version}.jar", "burp-suite"
  end

  test do
    system "#{bin}/burp-suite", "--help"
  end
end
