class Bettercap < Formula
  desc "Complete, modular, portable and easily extensible MITM framework"
  homepage "https://www.bettercap.org/"
  url "https://github.com/evilsocket/bettercap/archive/v1.6.2.tar.gz"
  sha256 "1b364d7e31be5fa7b5f93eefe76763ad7bd4ac0b7b6bb4af05483157580a9cb9"
  revision 2

  bottle do
    cellar :any
    sha256 "4fabf37e34f857110eb67a091736edb006bdb87d80e0a72c53272d2d8dc244b0" => :high_sierra
    sha256 "4fe944ffc04be24c8dd8fb2ce9c514b0c50f169f0e46a0d71f0439930abcd924" => :sierra
    sha256 "dae1ac47211601759da66f7a83e0ae7017d760acc7cf3bdc67e441d54bdc02bc" => :el_capitan
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
