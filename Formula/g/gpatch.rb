class Gpatch < Formula
  desc "Apply a diff file to an original"
  homepage "https://savannah.gnu.org/projects/patch/"
  url "https://ftpmirror.gnu.org/patch/patch-2.8.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/patch/patch-2.8.1.tar.xz"
  sha256 "3240c7959c5347c8ed347e3c4201c0337bf4240d5cf09d68889e58eeaba30e17"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b1381f45a7565f59b5e14294855454764e6e5464b784f2cffa3467a1b449834"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eae0f543c862bce1c2c4573bbb6ad58d2b28aa9afbf9d1e384b922474e82481a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "035c677c43e4d3563c180b7d628fcf227469e2207219d86c8d0059a1a5d63e0c"
    sha256 cellar: :any,                 arm64_linux:       "85b72be46eabb77cffc2140eb1c1b0c75fee19800390c433009195990c98740e"
    sha256 cellar: :any,                 x86_64_linux:      "fdb287af00677fbc8e72209e586632811c004ea178505cd48796362bae162c04"
  end

  deny_network_access!

  def install
    args = std_configure_args
    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args
    system "make", "install"

    return unless OS.mac?

    # Symlink the executable into libexec/gnubin as "patch"
    (libexec/"gnubin").install_symlink bin/"gpatch" => "patch"
    (libexec/"gnuman/man1").install_symlink man1/"gpatch.1" => "patch.1"
    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "patch" has been installed as "gpatch".
        If you need to use it as "patch", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    testfile = testpath/"test"
    testfile.write "homebrew\n"
    patch = <<~EOS
      1c1
      < homebrew
      ---
      > hello
    EOS
    if OS.mac?
      pipe_output("#{bin}/gpatch #{testfile}", patch)
    else
      pipe_output("#{bin}/patch #{testfile}", patch)
    end
    assert_equal "hello", testfile.read.chomp
  end
end
