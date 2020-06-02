class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.9.2.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.9.2.tar.xz"
  sha256 "7b383f26c67525205f96a4a3bfb27993396992794adda6fe05ad565f369f047c"

  bottle do
    sha256 "7e639bfe3df8a33f8ad5cd087699c072a2bb844abca7553292a2d15591399185" => :catalina
    sha256 "e583625d3afe9168d4d3c98be9ffa74324802db5748486eae84ccfdd0f5bc491" => :mojave
    sha256 "c622c3c27cc77573875f787eab628e1dd50a8d0fafa60e09678c554e2951cde8" => :high_sierra
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
