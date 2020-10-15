class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v2.0.0.tar.gz"
  sha256 "95d40608bac22b965712dc929143ebc994d44b2eb4782b99ba58a2deb1e38aa1"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a63ba2269f41885fcce0d21f35c0f2427ff98c3654d494e4a12f1a12dbac6d3d" => :catalina
    sha256 "91509ac325bec9d84a024f8bf18b95865970db30faa6743c09bd7936157af277" => :mojave
    sha256 "e1f7a53c510374bfa5decc916f06310687ffac23b476f8074c67bb61f37834ea" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.9" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    shell_output("#{bin}/austin #{Formula["python@3.9"].opt_bin}/python3 -c \"print('Test')\"", 33)
  end
end
