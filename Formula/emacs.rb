class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  license "GPL-3.0-or-later"

  stable do
    url "https://ftp.gnu.org/gnu/emacs/emacs-27.1.tar.xz"
    mirror "https://ftpmirror.gnu.org/emacs/emacs-27.1.tar.xz"
    sha256 "4a4c128f915fc937d61edfc273c98106711b540c9be3cd5d2e2b9b5b2f172e41"

    # The emacs binary is patched with a signature after linking. This invalidates the code
    # signature. Code signing is required on Apple Silicon. This patch adds a step to resign
    # the binary after it is patched.
    patch do
      url "https://github.com/emacs-mirror/emacs/commit/868f51324ac96bc3af49a826e1db443548c9d6cc.patch?full_index=1"
      sha256 "d2b19fcca66338d082c15fa11d57abf7ad6b40129478bef4c6234c19966db988"
    end

    # Back-ported patch for configure and configure.guess to allow configure to complete
    # for aarch64-apple-darwin targets.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/25c1e1797d4004a9e5b9453779399afc63d04b97/emacs/arm.patch"
      sha256 "5f812fc413b722e294c7f7abd38f3a9bbda84ec68537cea42900a81e57c7ecb1"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "66c4fc4a6f21c3303ac39939e8971894560fd4d8e632539e72436bd05a203816"
    sha256 big_sur:       "c4d216163623ccb65f21964df378f1c96871657cbc8ffa702dd3812e7d0e76d8"
    sha256 catalina:      "86274cfc78b97cf6b5e2e942b9283c2da926b8fa4a9a0400515661a9dccc7c24"
    sha256 mojave:        "8ed16db6ab57f13c9ec1104caf06388829118c8e94b13974f39d4c59d0faf612"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "jansson"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "jpeg"
  end

  def install
    # Mojave uses the Catalina SDK which causes issues like
    # https://github.com/Homebrew/homebrew-core/issues/46393
    # https://github.com/Homebrew/homebrew-core/pull/70421
    ENV["ac_cv_func_aligned_alloc"] = "no" if MacOS.version == :mojave

    args = %W[
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --with-gnutls
      --without-x
      --with-xml2
      --without-dbus
      --with-modules
      --without-ns
      --without-imagemagick
      --without-selinux
    ]

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

    File.write "lisp/site-load.el", <<~EOS
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrew/shims" elt) elt))
          exec-path)))
    EOS

    system "./configure", *args
    system "make"
    system "make", "install"

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    (bin/"ctags").unlink
    (man1/"ctags.1.gz").unlink
  end

  plist_options manual: "emacs"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/emacs</string>
          <string>--fg-daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
