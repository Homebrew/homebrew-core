class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftpmirror.gnu.org/gnu/findutils/findutils-4.11.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/findutils/findutils-4.11.0.tar.xz"
  sha256 "bfd19cb06cc71f3352d567e90284d8cdac02ac89774bbeadf0b533b0c11432fd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e29d12378878cca95d2b60703f7702e2ce7c37c8a4fe1636c0fc3b2ad2f82fa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e35180244a00d215d59d1e53f4a3da84f8e5a046c67e72e8d27dd4ce82c958df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ce14cc0e2a6ca3415118b94b1c388f337538a11208b9f4ef63b3be1522099ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "327fd9cdb2d0196d87f01e852f07c571caacdef69760cbe04cec4b91f3d8fbfd"
    sha256 cellar: :any,                 arm64_linux:   "83ac2251468e03755fa6cd602f99d652279ea1e234a8b809a6e3571199d8530b"
    sha256 cellar: :any,                 x86_64_linux:  "8b89e4687b71a6ed5b3c3d7e64adfd50901e000c4d1060b2cedd5f7c1dfcf01b"
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
