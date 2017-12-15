class Bettercap < Formula
  desc "Complete, modular, portable and easily extensible MITM framework"
  homepage "https://www.bettercap.org/"
  url "https://github.com/evilsocket/bettercap/archive/v1.6.2.tar.gz"
  sha256 "1b364d7e31be5fa7b5f93eefe76763ad7bd4ac0b7b6bb4af05483157580a9cb9"
  revision 1

  bottle do
    cellar :any
    sha256 "434b327d74c8e1e8b4096fcbc8b8d4cb4045ec2e58e9e249fbec3acdffc389b4" => :high_sierra
    sha256 "2b0b7417edb99220876a1f17bda0612cda33ffb835c955ce9d17153125e250fa" => :sierra
    sha256 "e846eee96fdad9755d4746d4996b913b625c40e8a8a8969fbaa47db9579ac82a" => :el_capitan
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
