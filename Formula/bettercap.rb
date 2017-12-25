class Bettercap < Formula
  desc "Complete, modular, portable and easily extensible MITM framework"
  homepage "https://www.bettercap.org/"
  url "https://github.com/evilsocket/bettercap/archive/v1.6.2.tar.gz"
  sha256 "1b364d7e31be5fa7b5f93eefe76763ad7bd4ac0b7b6bb4af05483157580a9cb9"
  revision 2

  bottle do
    cellar :any
    sha256 "a343c8664a135ed63fb08145ed7aacf1b00fcab1041b35e772104af47e12a22d" => :high_sierra
    sha256 "90f494066367e9792a9eddea4d0e3c1e158932fabda587b798f2dcbf9f5ffb07" => :sierra
    sha256 "76cc52b023dffd067441279ad42b3f127e5dc088d23c95b839a83dbf3a80b31c" => :el_capitan
  end

  depends_on "openssl"
  depends_on :ruby => "2.2.2"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include}"
    system "gem", "install", "bundler"
    system libexec/"bin/bundle", "install"
    system "gem", "build", "bettercap.gemspec"
    system "gem", "install", "bettercap-#{version}.gem"
    bin.install libexec/"bin/bettercap"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  def caveats; <<~EOS
    bettercap requires root privileges so you will need to run `sudo bettercap`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "This software must run as root.", pipe_output("#{bin}/bettercap --version 2>&1")
  end
end
