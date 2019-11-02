class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://cdn-aws.deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.9.tar.xz"
  sha256 "20975c5cb8cb305f28c2ac35dd99fd9f594f25b6140b5d478a0a364e9fa8073f"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcb0730027bed66729b843bf065c651c52c7edbfed0a46622c243866434b8d2b" => :mojave
    sha256 "af74b43a11ee50e69a88a8e0a3af7a6bce7e545d27bbb98ced8db7ceb94a96e9" => :high_sierra
    sha256 "567d6a92a370cd2b3d437c6fc6ba3d18047a2e8438d4e81c287ccd47beb635ec" => :sierra
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
