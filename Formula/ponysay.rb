class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  license "GPL-3.0"
  revision 6
  head "https://github.com/erkin/ponysay.git"

  stable do
    url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
    sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"

    # upstream commit 16 Nov 2019, `fix: do not compare literal with "is not"`
    patch do
      url "https://github.com/erkin/ponysay/commit/69c23e3a.patch?full_index=1"
      sha256 "2c58d5785186d1f891474258ee87450a88f799408e3039a1dc4a62784de91b63"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6a50e86cb011bd455d76f6478f230a543759fd622132914ac35c2423f63f410f" => :big_sur
    sha256 "60e7b68ff8b1547be4ed7410414a6cf3c707c105aea0ca82d8bac49a6a7bd476" => :arm64_big_sur
    sha256 "8c53b69ff726780b68fa8d644a13325bf46b80ae13eb198804f0eb7aa601a893" => :catalina
    sha256 "d91ddb61651ee73e49f565095257cf8226d66585d8032783fe208ee359448912" => :mojave
    sha256 "ba848b6de300211972228d752805e4d4bed7ba44af9356e0f56fc6bdd9f23f79" => :high_sierra
  end

  depends_on "gzip" => :build
  depends_on "coreutils"
  depends_on "python@3.9"

  uses_from_macos "texinfo" => :build

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{Formula["python@3.9"].opt_bin}/python3",
           "install"
  end

  test do
    output = shell_output("#{bin}/ponysay test")
    assert_match "test", output
    assert_match "____", output
  end
end
