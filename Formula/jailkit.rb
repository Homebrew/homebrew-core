class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.21.tar.bz2"
  sha256 "db3bb090a4fffdef59b5eafd594478d576cacf84306f9929d0dfbed090cf3687"

  bottle do
    rebuild 1
    sha256 "1bdfd57d829a6b90286601b2b13660b53cc14fe6443d0d23fa15636171c79439" => :catalina
    sha256 "43811f3b792ddd4039767cf81882e0c46c2851ba95546c01d7c1a052c3e99f3e" => :mojave
    sha256 "dd348dd5721fc813bb1556f13b196b684f5ef805f3c03c2bab1e3df4eef41376" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    ENV["PYTHONINTERPRETER"] = Formula["python@3.8"].opt_bin/"python3"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
