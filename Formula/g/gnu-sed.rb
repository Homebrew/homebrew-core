class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftpmirror.gnu.org/gnu/sed/sed-4.10.tar.xz"
  mirror "https://ftp.gnu.org/gnu/sed/sed-4.10.tar.xz"
  sha256 "b8e72182b2ec96a3574e2998c47b7aaa64cc20ce000d8e9ac313cc07cecf28c7"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "046672d06b2dd62a59d7088c58cec29749e436366e81dbe18f1b42cbad96fbb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2afabbecf1e1a0f324af43c3a7d76714e30afdc97a9d29f46d9d07dc80059ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beafe9167ff24d0c7bec394dfd710dba520f5f6cff89d604e718834f04e3cbc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "04dad428ef00e0d35bcbb5964058d96e53b01768232679e67f8fa59b13afc576"
    sha256                               arm64_linux:   "3dd83efc27792d0a9980bcdbd7d2601e27bf54fa9469bad29ead18d00eac4d34"
    sha256                               x86_64_linux:  "6c02e4e02bd27c0807dbfb2ff7759b66f992cd490102a67f5d76c4fd63e59f8d"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args += if OS.mac?
      %w[--program-prefix=g]
    else
      %w[
        --disable-acl
        --without-selinux
      ]
    end
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gsed" =>"sed"
      (libexec/"gnuman/man1").install_symlink man1/"gsed.1" => "sed.1"
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "sed" has been installed as "gsed".
        If you need to use it as "sed", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    test_file = testpath/"test.txt"
    test_file.write "Hello world!"
    if OS.mac?
      system bin/"gsed", "-i", "s/world/World/g", "test.txt"
      assert_match "Hello World!", test_file.read

      system opt_libexec/"gnubin/sed", "-i", "s/world/World/g", "test.txt"
    else
      system bin/"sed", "-i", "s/world/World/g", "test.txt"
    end
    assert_match "Hello World!", test_file.read
  end
end
