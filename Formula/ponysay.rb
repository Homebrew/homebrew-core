class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  revision 5
  head "https://github.com/erkin/ponysay.git"

  stable do
    url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
    sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"

    # upstream commit 16 Nov 2019, `fix: do not compare literal with "is not"`
    patch do
      url "https://github.com/erkin/ponysay/commit/69c23e3a.diff?full_index=1"
      sha256 "4343703851dee3ea09f153f57c4dbd1731e5eeab582d3316fbbf938f36100542"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1a6657b674719935d9ff4114119e2521ff967eb1ae13f72185d20e760949ee5b" => :catalina
    sha256 "f0a79ed95066b8ee79f4e117ae4344ac516c32a73e30e8f036abca646e7f3c56" => :mojave
    sha256 "a502ed3340bc2c7591788c8747c8175e0ac7902bfbfdf73454aef09d39a0db16" => :high_sierra
  end

  depends_on "gzip" => :build
  depends_on "coreutils"
  depends_on "python@3.8"

  uses_from_macos "texinfo" => :build

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{Formula["python@3.8"].opt_bin}/python3",
           "install"
  end

  test do
    output = shell_output("#{bin}/ponysay test")
    assert_match "test", output
    assert_match "____", output
  end
end
