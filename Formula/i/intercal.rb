class Intercal < Formula
  desc "Esoteric, parody programming language"
  homepage "http://catb.org/~esr/intercal/"
  url "http://catb.org/~esr/intercal/intercal-0.35.tar.gz"
  sha256 "b55e8edc68e2517a067a902766e2f57b97b502553fdcbae2b5ab2463ba58f0e1"
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

  bottle do
    sha256 sonoma:       "89bd47009d0b3badca873c9a90da5c598e37c3b8d321a5b193e7c7a2fb471bad"
    sha256 arm64_linux:  "0ba5bbd64a3a282d3f4e6d399d2db42e064a5377305db6ceaf3e0f32bf6b9185"
    sha256 x86_64_linux: "19b7f6bc3117e3fcd0bf5f3e707d2e96307cb2adc07179a19a4ce301d5edae8c"
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
