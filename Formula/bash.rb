class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  head "https://git.savannah.gnu.org/git/bash.git"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-5.0.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-5.0.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.0.tar.gz"
    sha256 "b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d"
    version "5.0.17"

    %w[
      001 f2fe9e1f0faddf14ab9bfa88d450a75e5d028fedafad23b88716bd657c737289
      002 87e87d3542e598799adb3e7e01c8165bc743e136a400ed0de015845f7ff68707
      003 4eebcdc37b13793a232c5f2f498a5fcbf7da0ecb3da2059391c096db620ec85b
      004 14447ad832add8ecfafdce5384badd933697b559c4688d6b9e3d36ff36c62f08
      005 5bf54dd9bd2c211d2bfb34a49e2c741f2ed5e338767e9ce9f4d41254bf9f8276
      006 d68529a6ff201b6ff5915318ab12fc16b8a0ebb77fda3308303fcc1e13398420
      007 17b41e7ee3673d8887dd25992417a398677533ab8827938aa41fad70df19af9b
      008 eec64588622a82a5029b2776e218a75a3640bef4953f09d6ee1f4199670ad7e3
      009 ed3ca21767303fc3de93934aa524c2e920787c506b601cc40a4897d4b094d903
      010 d6fbc325f0b5dc54ddbe8ee43020bced8bd589ddffea59d128db14b2e52a8a11
      011 2c4de332b91eaf797abbbd6c79709690b5cbd48b12e8dfe748096dbd7bf474ea
      012 2943ee19688018296f2a04dbfe30b7138b889700efa8ff1c0524af271e0ee233
      013 f5d7178d8da30799e01b83a0802018d913d6aa972dd2ddad3b927f3f3eb7099a
      014 5d6eee6514ee6e22a87bba8d22be0a8621a0ae119246f1c5a9a35db1f72af589
      015 a517df2dda93b26d5cbf00effefea93e3a4ccd6652f152f4109170544ebfa05e
      016 ffd1d7a54a99fa7f5b1825e4f7e95d8c8876bc2ca151f150e751d429c650b06d
      017 4cf3b9fafb8a66d411dd5fc9120032533a4012df1dc6ee024c7833373e2ddc31
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.0-patches/bash50-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-5.0-patches/bash50-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    sha256 "a124202b5a5c0896ab93c8603eefae655ef622d34f9e15e4d4aa77f1cd314c1d" => :catalina
    sha256 "dd9c4711dc1be6d54ea74143b224b21ab0d165fca090fbcb921efaa0c0bb2f12" => :mojave
    sha256 "d8c36b430ff928f72b33bad666f1ae2170802e85b8b51594c953e583fd4f11be" => :high_sierra
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
