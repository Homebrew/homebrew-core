class Bettercap < Formula
  desc "Complete, modular, portable and easily extensible MITM framework"
  homepage "https://www.bettercap.org/"
  url "https://github.com/evilsocket/bettercap/archive/v1.6.2.tar.gz"
  sha256 "1b364d7e31be5fa7b5f93eefe76763ad7bd4ac0b7b6bb4af05483157580a9cb9"
  revision 3

  bottle do
    cellar :any
    sha256 "f37cb67f4deaf5433c117339ea68350c01f88516001484443872cb4d4be830b5" => :high_sierra
    sha256 "5f6ed37beb8ad8525eb5fc226d17a8fe5893ecb29a0733347cfb5a7f8a2ade7f" => :sierra
    sha256 "c15257bc4fcc3d23bdb6e1204757230f6ca843b97507ef4ceefa824e8ec4838a" => :el_capitan
  end

  depends_on "openssl"
  depends_on "ruby" if MacOS.version <= :sierra

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
