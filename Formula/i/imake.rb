class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.11.tar.xz"
  sha256 "55955527eaebe94633e4083d4fe5f2160a65fe4c6dafdee48b89fea5f1ca8a78"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?imake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "e00d84afa586ef13b9a3839fb78191004c4bb76953057ccda30f602cc274565d"
    sha256 arm64_sequoia: "16145a844d8aaf431a839bc9d6c8ecc3ce22738e61536a1edfca0888ac8b9c20"
    sha256 arm64_sonoma:  "b21feb76732b8c591a4edc56c06904a411f58c7a406700f7aa1dfc42f14c7910"
    sha256 sonoma:        "63dbde50254d19999a5a6fd43f0107eb3cb7a5e43ef148eb27a725bc32f385e9"
    sha256 arm64_linux:   "513164454011b2cf9941f92eea4ad738a28b37265b3606838f26bd15223b2493"
    sha256 x86_64_linux:  "a5b7ebc580e66c9f4f72b61e1b6ad51228d41f25620d66e4959334bad6b5c15f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "tradcpp"

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.9.tar.xz"
    sha256 "07716eb1fe1fd1f8a1d6588457db0101cae70cb896d49dc65978c97b148ce976"
  end

  def install
    ENV.deparallelize

    # imake runtime is broken when used with clang's cpp
    cpp_program = Formula["tradcpp"].opt_bin/"tradcpp"
    (buildpath/"imakemdep.h").append_lines <<~C
      #define DEFAULT_CPP "#{cpp_program}"
      #undef USE_CC_E"
    C

    # also use gcc's cpp during buildtime to pass ./configure checks
    ENV["RAWCPP"] = cpp_program

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    resource("xorg-cf-files").stage do
      # Fix for different X11 locations.
      inreplace "X11.rules", "define TopXInclude	/**/",
                "define TopXInclude	-I#{HOMEBREW_PREFIX}/include"

      system "meson", "setup", "build", "-Dwith-config-dir=#{lib}/X11/config",
                      "--prefix=#{HOMEBREW_PREFIX}", "--buildtype=release", "--wrap-mode=nofallback"
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
  end

  test do
    # Use pipe_output because the return code is unimportant here.
    output = pipe_output("#{bin}/imake -v -s/dev/null -f/dev/null -T/dev/null 2>&1")
    assert_match "#{Formula["tradcpp"].opt_bin}/tradcpp", output
  end
end
