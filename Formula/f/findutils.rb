class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftpmirror.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz"
  sha256 "1387e0b67ff247d2abde998f90dfbf70c1491391a59ddfecb8ae698789f0a4f5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbf1fa06d2c0dd2b170e83266bfb76f9b59e6bd8a44423009aebdd23c99b5138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ba2122a404aa878c9dc830fa726bd16b15c6c01a00b14837064b788c1deba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f132d0f2ed5d4805e0c1b6266b7899298d79eb2e79231b3c023e9eba2a4f46e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee53e5aa5b42856fe2feb224eb8348714e47bfdadb7084f903750ec0d6a9b0f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc2f7cef22fbf5d5926c972fc0340c3c5a2063b744dd86e34df16192e4adcfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6eca32ebb39b10a1e1f6f78fb60ff1ad2c5b0f9e87c8dcb90ff9a113776fab1"
  end

  def install
    args = %W[
      --disable-nls
      --localstatedir=#{var}/locate
      --with-packager=Homebrew
      --with-packager-bug-reports=#{tap.issues_url}
    ]
    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"

    if OS.mac?
      [[prefix, bin], [share, man/"*"]].each do |base, path|
        Dir[path/"g*"].each do |p|
          f = Pathname.new(p)
          gnupath = "gnu" + f.relative_path_from(base).dirname
          (libexec/gnupath).install_symlink f => f.basename.sub(/^g/, "")
        end
      end
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
    (var/"locate").mkpath
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    touch "HOMEBREW"
    if OS.mac?
      assert_match "HOMEBREW", shell_output("#{bin}/gfind .")
      assert_match "HOMEBREW", shell_output("#{opt_libexec}/gnubin/find .")
    else
      assert_match "HOMEBREW", shell_output("#{bin}/find .")
    end
  end
end
