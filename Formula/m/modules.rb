class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.6.0/modules-5.6.0.tar.bz2"
  sha256 "21c9041b7aac341c01b89e4fef0c5414e6928632ec839e86fc6dcb4c9503e6d4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62ac4cbc56519b920329ce5fb23d78c833645931c5b9afb576796ca6bec79778"
    sha256 cellar: :any,                 arm64_sequoia: "b96474bcebc53d36afddc6c40d58bf86d37df3c82ae5fc04c07654abc0d1466b"
    sha256 cellar: :any,                 arm64_sonoma:  "d0230d446fa7be1f6b5c78618182ffc5da2c0e3560421525fb97133f28f0b75b"
    sha256 cellar: :any,                 arm64_ventura: "d9c87d45370d3f46537bb407c58bab470acec1634c1050de5fd3317645bb51ff"
    sha256 cellar: :any,                 sonoma:        "5855253b417699a3f4b3c58bb32cef094f5e3de694ddb34c02a54c3fd7aea587"
    sha256 cellar: :any,                 ventura:       "782be9a7bd7c67dc16bfca7653d32e90bfcbc8b87f03912e2a5421c747d8d9e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b9ae7b3d2fd96b3e08b8b597e801218f581c56a0c91f020cc07fe5696fbda76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa7ac949189ecb64f38abd9bae6049f03436c99db250f526fa86a7d382f99cbb"
  end

  depends_on "tcl-tk"

  uses_from_macos "less"

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{tcltk.opt_lib}
      --with-tclsh=#{tcltk.opt_bin}/tclsh
      --without-x
    ]
    args << "--with-pager=#{Formula["less"].opt_bin}/less" if OS.linux?

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
