class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.9.1.tar.xz"
  sha256 "af826685d9c56abfa873e84cd392539cd363cb0ba04a09d21187377e1b764091"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1f977f77dcca9def37363e95e3ccd1c908accb73085874174588624c69bc283" => :catalina
    sha256 "d35377b1fd012794a0dea183979cd01cdcf8d20d6c8244c9982c23a0fb8763d5" => :mojave
    sha256 "b99af4db44a1f0a81188fe871a731debe8760e5c435ed41f6fc037ab3a6d799a" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_predicate Pathname.new(output), :exist?
  end
end
