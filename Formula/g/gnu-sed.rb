class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.9.tar.xz"
  sha256 "6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7bf9b1bc4e946b0f316cfe1aeacc5fbf418d0045588d381f35439d96dba64f4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ffd49517ed790e52a088e720de77f1dd4de4e88816fb6a1d244be3f6b01314d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3770e9098033bc1f32427d3b6502a1ab10082b3945e204286c87060d82d03d19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e41980dc2d528301c562ed7ec59ee8bcfe43d1f9a4dc734652e9c216ac3fbdf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d10e5703feb75bc37e450178f2c6bdc3a6b2cf9eb72594cfab90f89b270136c"
    sha256 cellar: :any_skip_relocation, ventura:        "66f640fbd1291801c04dc8af37378c051aa1ddbb3a620df2b4b85b9f0f6df80e"
    sha256 cellar: :any_skip_relocation, monterey:       "0f63397072520ce4c163974de6f0313a9117d106890c8cb0fb9344c723543674"
    sha256                               x86_64_linux:   "6ecac3ffdd0517ed1516ff18d79d4ea44f761b6fb2a5040c124bb51da35c03e1"
  end

  conflicts_with "ssed", because: "both install share/info/sed.info"

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
