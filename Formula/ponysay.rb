class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  license "GPL-3.0"
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
    sha256 "77e5eb82496f017ceec2250b454b536964aff0609e3ab2a4a785b9d9b62c5393" => :catalina
    sha256 "30dbf5ef6f9aed9feaf26557e8c954eef25102e79c4c8c020d98d25bbb737bab" => :mojave
    sha256 "78743696032607c87bd59c95f765d6e10f2758be4b152728ae3b9ddbfb16e5cd" => :high_sierra
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
