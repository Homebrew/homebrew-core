class Gpatch < Formula
  desc "Apply a diff file to an original"
  homepage "https://savannah.gnu.org/projects/patch/"
  url "https://ftpmirror.gnu.org/gnu/patch/patch-2.8.tar.xz"
  mirror "https://ftp.gnu.org/gnu/patch/patch-2.8.tar.xz"
  sha256 "f87cee69eec2b4fcbf60a396b030ad6aa3415f192aa5f7ee84cad5e11f7f5ae3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c79a8b5d256e2208b32446babb95be637d48bf1fa571bca1773c9c73414ca3ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01993d9f869309a9494840d4da0ed1997b4d21181679fd226bb9038a0e59f81e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "692a394eae0b5a7fd95bb25822e8750cd493f9afee1e5db272f6445c88ae3bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78c60664e4eb56d03f582b2ca45a1f3861ae6a331bd9f7997ce587ac2415b440"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c46ba36e9b3e9fee27bd96ea873caa2a5938119a0e1dbd241fe408eca239a1f"
    sha256 cellar: :any_skip_relocation, ventura:       "c953a2bb4faddd18394392879c8dce68094772834f5f9de162bd87657f56b8a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "390fa81b06e4db0aca8c86068b653c3dc27494508c4febd61ee647fb2deb4ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f0d5010f2d0a3e11af30cc8b7b5982b1da2c7badc027f01d4fb33f2e6cc2bb"
  end

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
