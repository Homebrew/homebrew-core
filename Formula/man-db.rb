class ManDb < Formula
  desc "Unix documentation system"
  homepage "http://man-db.nongnu.org/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.8.5.tar.xz"
  sha256 "b64d52747534f1fe873b2876eb7f01319985309d5d7da319d2bc52ba1e73f6c1"

  bottle do
    sha256 "4d1631d07729c3bc4187b3cdd2d617719dc1c50dfb8b54c4327b31e4634064d0" => :mojave
    sha256 "82831641ca694f5c3a50ed2a8dc5473fc620d15d5a30d715b15d240f94c28656" => :high_sierra
    sha256 "3ec775fb15d55188d1f9ad5f35863a46d8013c9f77ac2847848980fc5f775451" => :sierra
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

  test do
    ENV["PAGER"] = "cat"
    output = shell_output("#{bin}/gman true")
    assert_match "BSD General Commands Manual", output
    assert_match "The true utility always returns with exit code zero", output
  end
end
