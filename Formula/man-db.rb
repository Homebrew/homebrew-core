class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.9.1.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.9.1.tar.xz"
  sha256 "ba3d8afc5c09a7265a8dabfa0e7c1f4b3ab97df9abf1f6810faa8f301056c74f"

  bottle do
    sha256 "45481f46236862a4486f5db8bc26aa791b416e9fd18c6c4aec2aa27d6ba85a6e" => :catalina
    sha256 "2b9775d73d7ef2f38b1da2674001507d479bdfb0447ea378b0b3e7eae16c1c82" => :mojave
    sha256 "7a56e47d3ba0239fb5cdd3a0d8c9c895946fc1cc2cbc552b45096511c5db9b4b" => :high_sierra
  end

  depends_on "pkg-config" => :build

  uses_from_macos "groff"
  uses_from_macos "zlib"

  resource "libpipeline" do
    url "https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.2.tar.gz"
    sha256 "fd59c649c1ae9d67604d1644f116ad4d297eaa66f838e3dfab96b41e85b059fb"
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

    system "./configure", *args

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

  def caveats
    <<~EOS
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
