class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.4.0/modules-5.4.0.tar.bz2"
  sha256 "c494f70cb533b5f24ad69803aa053bb4a509bec4632d6a066e7ac041db461a72"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3639cfdff6c74336a2c5e3712bc65df6cd01bd76486837273777633c7915c979"
    sha256 cellar: :any,                 arm64_sonoma:   "4ddaf539544c8f1517733ceddf0c1573d6a4caa3778b1aeb08aa889b2d384b63"
    sha256 cellar: :any,                 arm64_ventura:  "507bddc8fdab17470d830eeadb5f24d10f606a7b4ad826e4c9fb22f8ac62a9dd"
    sha256 cellar: :any,                 arm64_monterey: "1880dfbab7812d4ade82d23498daff830f7985173b4538cb587137b64325cb90"
    sha256 cellar: :any,                 sonoma:         "59f7699c5b3a4aae9de29e0be0185f83495b73fc5300f0b3c210afe4acef39bb"
    sha256 cellar: :any,                 ventura:        "907d341c7bcd83ad6a2d3f02311585b1aa3ad0150ebdfeeb090d6f655b6ad4a0"
    sha256 cellar: :any,                 monterey:       "de88a0bb8dda06d5ac93d16b7b0a2d2e197c765aaabb4ad8847fe47b58aac9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01c5ac7e9fdd7fcf80e195809215244ab183da70646a6be1d62b0920ac6aba1"
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
