class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.21.tar.bz2"
  sha256 "db3bb090a4fffdef59b5eafd594478d576cacf84306f9929d0dfbed090cf3687"
  revision 1

  bottle do
    sha256 "58761380572c700e95ae78a62c76fecb897a390837d38748651622b5762c8681" => :big_sur
    sha256 "9b1811caafbdea42e49b14308f79e70faccbb3f38402184f974e52026c220a57" => :arm64_big_sur
    sha256 "488323402cd9c3487e515ebe4ed8b4e056188af3d125ee063a1056c58c1c61a4" => :catalina
    sha256 "6aeb6044ff3ba537d8575fea45053da11764549b72d545df3b962b6a6d3ee68c" => :mojave
    sha256 "7ab554fa425961fe843c0533b360b5f0eb7dcc39ed707e6f757e0c4e328d930c" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    ENV["PYTHONINTERPRETER"] = Formula["python@3.9"].opt_bin/"python3"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
