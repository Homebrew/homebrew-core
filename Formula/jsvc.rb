class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.cgi?path=commons/daemon/source/commons-daemon-1.1.0-native-src.tar.gz"
  sha256 "11962bc602619fd2eeb840f74a8c63cc1055221f0cc385a1fa906e758d39888d"

  bottle do
    cellar :any_skip_relocation
    sha256 "751f890d542cdb78a6d6ba81f00600452576160e8f1293cc28b13e136ff7220c" => :mojave
    sha256 "867f5db60424ee34f1d72059cb3f60ace96abeca8005c85e4401006b53db1aa5" => :high_sierra
    sha256 "d67d2a5120584d15afca82c5100c0314c0c865e51f982f1512f2deebbcb14b08" => :sierra
    sha256 "c3c5ea34eeea62e0c7fc379e6691eed05edbb4ceabe2c568683acd474061e565" => :el_capitan
  end

  depends_on :java

  def install
    ENV.append "CFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "LDFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "CPPFLAGS", "-I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers"

    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "unix"
    system "./configure", "--with-java=/System/Library/Frameworks/JavaVM.framework",
                          "--with-os-type=Headers"
    system "make"
    bin.install "jsvc"
  end
end
