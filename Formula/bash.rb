class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  head "https://git.savannah.gnu.org/git/bash.git"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.0.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-5.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-5.0.tar.gz"
    mirror "https://gnu.cu.be/bash/bash-5.0.tar.gz"
    mirror "https://mirror.unicorncloud.org/gnu/bash/bash-5.0.tar.gz"
    sha256 "b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d"
    version "5.0.3"

    %w[
      001 f2fe9e1f0faddf14ab9bfa88d450a75e5d028fedafad23b88716bd657c737289
      002 87e87d3542e598799adb3e7e01c8165bc743e136a400ed0de015845f7ff68707
      003 4eebcdc37b13793a232c5f2f498a5fcbf7da0ecb3da2059391c096db620ec85b
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://gnu.cu.be/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://mirror.unicorncloud.org/gnu/bash/bash-5.0-patches/bash50-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    sha256 "6573f80429e70d699ef4c352c5a25575a15924d126a6ca6aede797fb47ce1068" => :mojave
    sha256 "153f3cde71a02dad3d763a8516e14b45525bd4008eaf89d67fda820623249afe" => :high_sierra
    sha256 "92e65ddb78c110783313f99ed331a650ce21692bc4bb827d031e5e34cacf420b" => :sierra
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

  def caveats; <<~EOS
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
  EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo -n hello\"")
  end
end
