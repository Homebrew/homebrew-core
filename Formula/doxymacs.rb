class Doxymacs < Formula
  desc "Elisp package for using doxygen under Emacs"
  homepage "https://doxymacs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/doxymacs/doxymacs/1.8.0/doxymacs-1.8.0.tar.gz"
  sha256 "a23fd833bc3c21ee5387c62597610941e987f9d4372916f996bf6249cc495afa"

  bottle do
    cellar :any_skip_relocation
    sha256 "48298f0f0b797c18f3af78a77a0f09f9db3880dc9d85771794894da348aedf1c" => :mojave
    sha256 "29a4865170b12a2194c238c35ec5e0902b8e637e378f9013b7aef64fa21eb0fc" => :high_sierra
    sha256 "2fd3dc59a8c0c8fdccf8195265d320aaa7b5d67e9a81b5a085f27cc287e7370e" => :sierra
    sha256 "fb892db831aed57dbdcb2d3a81d78bd05c5b689376d4b7f14bffc56826205ce9" => :el_capitan
    sha256 "09eb19921c2ecce5bb02b185c1040caef07d18706866006bdd5fa428bf6b8560" => :yosemite
    sha256 "9efc35f7eee0ff431afbd36367676afb608498f823e6094b67d4c86d83694dd4" => :mavericks
  end

  head do
    url "https://git.code.sf.net/p/doxymacs/code.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "doxygen"
  depends_on "emacs"

  def install
    # Fix undefined symbols errors for _xmlCheckVersion and other symbols
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra || MacOS.version == :el_capitan

    # https://sourceforge.net/p/doxymacs/support-requests/5/
    ENV.append "CFLAGS", "-std=gnu89"

    # Fix undefined symbol errors for _xmlCheckVersion, etc.
    # This prevents a mismatch between /usr/bin/xml2-config and the SDK headers,
    # which would cause the build system not to pass the LDFLAGS for libxml2.
    ENV.prepend_path "PATH", "#{MacOS.sdk_path}/usr/bin"

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "doxymacs")
      (print doxymacs-version)
    EOS
    output = shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
    assert_equal "\"#{version}\"", output
  end
end
