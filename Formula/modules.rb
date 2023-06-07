class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.3.0/modules-5.3.0.tar.bz2"
  sha256 "70c165082e42e4faeaf9e18590ff0652b2fccb2184d873459700adfbff4f753e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d43be4aae15dd968db359e226545bf4fb75147169378f90f022b0a460d5717f"
    sha256 cellar: :any,                 arm64_monterey: "673188ba40af9a15e68cf6b37edfe0c1dbeaa7becf5b421f19ddb099c60fd18e"
    sha256 cellar: :any,                 arm64_big_sur:  "5b05635803f14caec308f4780561f93f76b286acc3cbe7243489b77068917328"
    sha256 cellar: :any,                 ventura:        "00c3a1d7d9f27d9ba164e3c27090d63798a9a66402e25a0f19fc18fc0c9e62a1"
    sha256 cellar: :any,                 monterey:       "30bff55cd3084c9c2f663ca90c7511d50cdef72989761c502c667cc4dfe6878c"
    sha256 cellar: :any,                 big_sur:        "ead17215b2a49b6307bb91c30dbcc5edc308f71cea8379cec80bca408ea75413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa1f73c6df4a996cd4c8c250809341848c65db760b9fe23888c5063aa6081b0d"
  end

  depends_on "tcl-tk"

  uses_from_macos "less"

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
