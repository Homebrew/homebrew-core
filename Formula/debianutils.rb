class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.8.6.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/debianutils/debianutils_4.8.6.tar.xz"
  sha256 "db09047144dadf6a35d0f28977fbef83b0dd60ca32e6c8512cce2444a6423f73"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac15a7442e74e2efe7af79c8f64f07369356fefb3300503012323f08c5ca3507" => :mojave
    sha256 "65d07fd030d0c4d6d72ce61090ab23cf4a8dfd77718a608a9ed53acfb87c59e7" => :high_sierra
    sha256 "37e20aa552607720417a814fadafb1f0fda6c9fd3d94d5173986ee95540b59fe" => :sierra
    sha256 "25b66356579ae53a7e8ef951170dd51fd8b7769ebcb58d3ca017cec17994520e" => :el_capitan
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
