class JdkDownloadStrategy < CurlDownloadStrategy
  def _curl_opts
    super << "--cookie" << "oraclelicense=accept-securebackup-cookie"
  end
end

class Jdk7 < Formula
  homepage "http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"
  # tag "linuxbrew"

  version "1.7.0.75"
  if OS.linux?
    url "http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz",
      :using => JdkDownloadStrategy
    sha256 "460959219b534dc23e34d77abc306e180b364069b9fc2b2265d964fa2c281610"
  elsif OS.mac?
    url "http://java.com/"
  end

  bottle :unneeded

  conflicts_with "jdk", :because => "both install bin/java"

  def install
    odie "Use 'brew cask install Caskroom/versions/java7' on Mac OS" if OS.mac?
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    By installing and using JDK you agree to the
    Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX
    http://www.oracle.com/technetwork/java/javase/terms/license/index.html
    EOS
  end

  test do
    system "#{bin}/java", "-version"
    system "#{bin}/javac", "-version"
  end
end
