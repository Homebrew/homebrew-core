class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.1.1/modules-5.1.1.tar.bz2"
  sha256 "28354dd1ab2ff25e9fb9ce759c77eeefec21f22a112d579fbf3cc802174ec944"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_monterey: "2005834a21f066f38329001986c72f6d573fbdd76aefe8260ab479929a32dc61"
    sha256                               arm64_big_sur:  "b4b13c216d76fcc9cbfa735d2745ce08241779efeded492f47e564242b7ffa01"
    sha256                               monterey:       "aea8ee2737cefa69cdb09f39cd4fa16b30f913a817671828d748b356f260ab74"
    sha256                               big_sur:        "6cbec1b70253d7a38fa308dd3a1eea3ceadb884f3f959c8fd56d9ee4320adbe7"
    sha256 cellar: :any,                 catalina:       "6ded93be3b9acdabd905c95b21a784c0ae497b03901738fad026bd30edeef7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60fec8d3cd399e851436459e79b62f4ee627dc0e5a59fb6ed62bc25a4cee8b22"
  end

  depends_on "tcl-tk"

  on_linux do
    depends_on "less"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{Formula["tcl-tk"].opt_lib}
      --without-x
    ]

    if OS.linux?
      args << "--with-pager=#{Formula["less"].opt_bin}/less"
      args << "--with-tclsh=#{Formula["tcl-tk"].opt_bin}/tclsh"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:

        source #{opt_prefix}/init/zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    shell, cmd = if OS.mac?
      ["zsh", "source"]
    else
      ["sh", "."]
    end
    output = shell_output("#{shell} -c '#{cmd} #{prefix}/init/#{shell}; module' 2>&1")
    assert_match version.to_s, output
  end
end
