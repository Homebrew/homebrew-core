class Intercal < Formula
  desc "Esoteric, parody programming language"
  homepage "http://catb.org/~esr/intercal/"
  url "http://catb.org/~esr/intercal/intercal-0.33.tar.gz"
  sha256 "211e0c5bbfe8064d28a4ca366cb87d64a2a87d5b43aa5eebccae092bacf1e1ca"
  license "GPL-2.0-or-later"

  # The latest version tags in the Git repository are `0.31` (2019-06-12) and
  # `0.30` (2015-04-02) but there are older versions like `1.27` (2010-08-25)
  # and `1.26` (2010-08-25). These two older 1.x releases are wrongly treated
  # as newer but the GitLab project doesn't do releases, so we can only
  # reference the tags. We work around this by restricting matching to 0.x
  # releases for now. If the major version reaches 1.x in the future, this
  # check will also need to be updated.
  livecheck do
    url :head
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 sonoma:       "d9b34181204263b17a9046ea236d9a2ef7eb49b9de6415349b7408f86aa21ead"
    sha256 arm64_linux:  "88da8548d1711605f7fd7f8047a53b9526f09b42951f4bed028d2a3bb177d8ce"
    sha256 x86_64_linux: "40cc61c43817df434de521373dd522acc5d65cd28c6ee74abe1bf6ab7a377d43"
  end

  head do
    url "https://gitlab.com/esr/intercal.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on arch: :x86_64 # test fails on arm64

    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make `depends_on :linux` when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  def install
    # clang doesn't support -fno-toplevel-reorder, so we
    # edit it out for macOS only.
    if OS.mac?
      %w[buildaux/Makefile.in buildaux/Makefile.am].each do |file|
        inreplace file, /\\\s*\n\s*-fno-toplevel-reorder/, "" if File.exist?(file)
      end
    end

    if build.head?
      cd "buildaux" do
        system "./regenerate-build-system.sh"
      end
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (etc/"intercal").install Dir["etc/*"]
    pkgshare.install "pit"
  end

  test do
    (testpath/"lib").mkpath
    (testpath/"test").mkpath
    cp pkgshare/"pit/beer.i", "test"
    cd "test" do
      system bin/"ick", "-b", "beer.i"
      system "./beer"
    end
  end
end
