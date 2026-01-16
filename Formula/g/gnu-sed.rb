class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftpmirror.gnu.org/gnu/sed/sed-4.9.tar.xz"
  mirror "https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz"
  sha256 "6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48a39d1b81adb766f45db53a0f4f8e9ce8b942386c270cfcdad3fbd08cb653f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70edbfd4aa9ec24bd48e21353d18433741c13ec10c9903d5c93349eabb83bebb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "829d21105387351f6c7b07cd845d7e234c1a460ea5e50cc2f5dbcface45e378d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a9b26c3bd0bdcfc258a24bb6b16eaf8677deaa5242adb8153f5ef0799f16946"
    sha256 cellar: :any_skip_relocation, sonoma:        "4993928cc2d43c4eeb320e5851bb4d2ab31bd88a1c52f287141af18e46afc4b9"
    sha256 cellar: :any_skip_relocation, ventura:       "9308ada3186ff94fafa9f3c8f2d937de4c2c4cde7ceeb2a69984095b072d795c"
    sha256                               arm64_linux:   "6a3e57a3c43b15a0bd0cfe27e176f0b935650fd482a028a184dbb6b67f47d0a9"
    sha256                               x86_64_linux:  "1b67527e8abadc04f961bb46ac20e54f731bcfe485d2813932735096f34ceca8"
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
