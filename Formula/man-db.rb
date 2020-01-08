class ManDb < Formula
  desc "Unix documentation system"
  homepage "http://man-db.nongnu.org/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.8.5.tar.xz"
  sha256 "b64d52747534f1fe873b2876eb7f01319985309d5d7da319d2bc52ba1e73f6c1"
  revision 1

  bottle do
    sha256 "7020922156beba59a49ce7d858f370d6fb1884ed2debaf8c57a09b4c37096a14" => :catalina
    sha256 "d068d781ba8482dd4e00b14d514e8bbaa30600ed286f0c422e09524e3e8a4247" => :mojave
    sha256 "4ee0fb987e13ced600fdbc6159e75f5303510e937d94ed78ccd0610eb8eac601" => :high_sierra
    sha256 "6054a6367980207aad35a40f0147e389e8f4db1691f42056111448389c61f23b" => :sierra
  end

  depends_on "pkg-config" => :build

  resource "libpipeline" do
    url "https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.1.tar.gz"
    sha256 "d633706b7d845f08b42bc66ddbe845d57e726bf89298e2cee29f09577e2f902f"
  end

  def install
    resource("libpipeline").stage do
      system "./configure",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{buildpath}/libpipeline",
        "--enable-static",
        "--disable-shared"
      system "make"
      system "make", "install"
    end

    ENV["libpipeline_CFLAGS"] = "-I#{buildpath}/libpipeline/include"
    ENV["libpipeline_LIBS"] = "-L#{buildpath}/libpipeline/lib -lpipeline"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-cache-owner
      --disable-setuid
      --program-prefix=g
    ]

    # NB: Remove once man-db 2.8.6 is released
    # https://git.savannah.gnu.org/cgit/man-db.git/commit/?id=b74c839eaa5000a18d1c396e995eca85b0e9464b
    args += %w[
      --without-systemdtmpfilesdir
      --without-systemdsystemunitdir
    ]

    system "./configure", *args

    # NB: Remove once man-db 2.8.6 is released
    # https://git.savannah.gnu.org/cgit/man-db.git/commit/?id=056e8c7c012b00261133259d6438ff8303a8c36c
    ENV.append_to_cflags "-Wl,-flat_namespace,-undefined,suppress"

    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "install"

    # Symlink commands without 'g' prefix into libexec/bin and
    # man pages into libexec/man
    %w[apropos catman lexgrog man mandb manpath whatis].each do |cmd|
      (libexec/"bin").install_symlink bin/"g#{cmd}" => cmd
    end
    (libexec/"sbin").install_symlink sbin/"gaccessdb" => "accessdb"
    %w[apropos lexgrog man manconv manpath whatis zsoelim].each do |cmd|
      (libexec/"man"/"man1").install_symlink man1/"g#{cmd}.1" => "#{cmd}.1"
    end
    (libexec/"man"/"man5").install_symlink man5/"gmanpath.5" => "manpath.5"
    %w[accessdb catman mandb].each do |cmd|
      (libexec/"man"/"man8").install_symlink man8/"g#{cmd}.8" => "#{cmd}.8"
    end

    # Symlink non-conflicting binaries and man pages
    %w[catman lexgrog mandb].each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
    end
    sbin.install_symlink "gaccessdb" => "accessdb"

    %w[accessdb catman mandb].each do |cmd|
      man8.install_symlink "g#{cmd}.8" => "#{cmd}.8"
    end
    man1.install_symlink "glexgrog.1" => "lexgrog.1"
  end

  def caveats; <<~EOS
    Commands also provided by macOS have been installed with the prefix "g".
    If you need to use these commands with their normal names, you
    can add a "bin" directory to your PATH from your bashrc like:
      PATH="#{opt_libexec}/bin:$PATH"
  EOS
  end

  test do
    ENV["PAGER"] = "cat"
    output = shell_output("#{bin}/gman true")
    assert_match "BSD General Commands Manual", output
    assert_match "The true utility always returns with exit code zero", output
  end
end
