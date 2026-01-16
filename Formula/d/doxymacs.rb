class Doxymacs < Formula
  desc "Elisp package for using doxygen under Emacs"
  homepage "https://doxymacs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/doxymacs/doxymacs/1.8.0/doxymacs-1.8.0.tar.gz"
  sha256 "a23fd833bc3c21ee5387c62597610941e987f9d4372916f996bf6249cc495afa"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe13bd89660f57f1c74c95e0b0ae7def510c8a80d6a9ec1bb05799153d546496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e22393964e0e2f3f1b841be5fcadcf4cacc9d6ac8597e4ba77cdd2a883e0417a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b772c42b30f9e256e9ff43da7d3a5e184cc2c5d535431f78f92282774889205e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe9b383131419cf3949ee0f039b501a8d518e6ab92368123d537800d85bc7333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35833ff40dab157ebfaed94448b822bbc044a87ab1e57d09aba41d13c200c1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87d7b48342fe0049e9c50a632c74a0d4fb8abca3928e2875871e69487cd8d387"
  end

  head do
    url "https://git.code.sf.net/p/doxymacs/code.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "doxygen"
  depends_on "emacs"

  uses_from_macos "libxml2"

  def install
    # https://sourceforge.net/p/doxymacs/support-requests/5/
    ENV.append "CFLAGS", "-std=gnu89"

    # Fix undefined symbol errors for _xmlCheckVersion, etc.
    # This prevents a mismatch between /usr/bin/xml2-config and the SDK headers,
    # which would cause the build system not to pass the LDFLAGS for libxml2.
    ENV.prepend_path "PATH", "#{MacOS.sdk_path}/usr/bin" if OS.mac?

    system "./bootstrap" if build.head?
    system "./configure", "--with-lispdir=#{elisp}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.el").write <<~LISP
      (add-to-list 'load-path "#{elisp}")
      (load "doxymacs")
      (print doxymacs-version)
    LISP

    output = shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
    assert_equal "\"#{version}\"", output
  end
end
