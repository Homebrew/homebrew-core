class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.21.tar.bz2"
  sha256 "db3bb090a4fffdef59b5eafd594478d576cacf84306f9929d0dfbed090cf3687"

  bottle do
    sha256 "b0980932e53c18886c0106fd50a6101fc77754fcfb536bf218fd6845f7e91309" => :catalina
    sha256 "1aae3a9499ec0553b45b48003e43c55e1facd7b56d94cc4ff9cb639496b7fa05" => :mojave
    sha256 "25e55b2cc8572ad043c97ad2b86e08f93ef1a69c6fb66d1bf1630c4c5092bdfc" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    ENV["PYTHONINTERPRETER"] = Formula["python@3.8"].opt_bin/"python3"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
