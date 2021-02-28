class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.9.4.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.9.4.tar.xz"
  sha256 "b66c99edfad16ad928c889f87cf76380263c1609323c280b3a9e6963fdb16756"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "341d1ed539d162400e216d4a7fa9fd1c1254cc1a408fb72cca8623f1582ab346"
    sha256 big_sur:       "3215d9a7659251e84cfc973926cf25fbd913b787a219e05697b2bf69067de7bf"
    sha256 catalina:      "9c8abb3fe66f90f4bc28ff8bc657fa8eabdacee5b69e0dbc554f8d319fa0948e"
    sha256 mojave:        "1c1760b6a478253caeb8d5535cac5a9466e2f03b1e6e5e9a1f6ee519b752adfb"
  end

  depends_on "pkg-config" => :build
  depends_on "groff"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gdbm"
  end

  resource "libpipeline" do
    url "https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.3.tar.gz"
    sha256 "5dbf08faf50fad853754293e57fd4e6c69bb8e486f176596d682c67e02a0adb0"
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
      --disable-nls
      --program-prefix=g
    ]

    system "./configure", *args

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
