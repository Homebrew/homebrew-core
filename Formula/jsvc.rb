class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.cgi?path=commons/daemon/source/commons-daemon-1.1.0-native-src.tar.gz"
  sha256 "11962bc602619fd2eeb840f74a8c63cc1055221f0cc385a1fa906e758d39888d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdaf73729ab305e94286ed4497f44de9c701bfd0ef9d954e597c460613a3ee57" => :high_sierra
    sha256 "5e570fb6500eff4bc3c9dd89bee0afe085d87c16d8038dcbb19d19fbeddb656c" => :sierra
    sha256 "f42f7315d5015da70971e6771fd3fe1b8aebeb6852c48d8a921d37ad5753ed05" => :el_capitan
    sha256 "ee2cdf6d939f8cbde26edbde512d6afa3c57a144c83f3a11699fe998b3d71815" => :yosemite
    sha256 "b97d2c0458b7280e197c420af87edd7f798b8ca6d3e0520a458750eaab5fbf68" => :mavericks
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
