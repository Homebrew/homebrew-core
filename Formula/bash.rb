class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-5.1.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-5.1.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.1.tar.gz"
    sha256 "cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa"
    version "5.1.4"

    %w[
      001 ebb07b3dbadd98598f078125d0ae0d699295978a5cdaef6282fe19adef45b5fa
      002 15ea6121a801e48e658ceee712ea9b88d4ded022046a6147550790caf04f5dbe
      003 22f2cc262f056b22966281babf4b0a2f84cb7dd2223422e5dcd013c3dcbab6b1
      004 9aaeb65664ef0d28c0067e47ba5652b518298b3b92d33327d84b98b28d873c86
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-5.1-patches/bash51-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-5.1-patches/bash51-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.1-patches/bash51-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-5.1-patches/bash51-#{p}"
        sha256 checksum
      end
    end
  end

  livecheck do
    url :stable
    regex(/href=.*?bash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "1c7c13309368474e6f7b3afd9c6ba13b213b00caeb9b990e171cf5e097e8e5e1" => :big_sur
    sha256 "253a8f71bb8ca1444fa5951caa3e4d0e6f51ca6cd6d7c9fc9f79f0c58dc3e693" => :arm64_big_sur
    sha256 "2195ea39cf6607ec440addd6aed524c5a66719e998d74d5f9595f594f6593b21" => :catalina
    sha256 "4a294caec86652221a9901b9d892723a84e60d05bc91155efcb661829b13a898" => :mojave
  end

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo -n hello\"")
  end
end
