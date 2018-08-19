class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  head "https://git.savannah.gnu.org/git/bash.git"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-4.4.tar.gz"
    mirror "https://gnu.cu.be/bash/bash-4.4.tar.gz"
    mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4.tar.gz"
    sha256 "d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb"
    version "4.4.23"

    %w[
      001 3e28d91531752df9a8cb167ad07cc542abaf944de9353fe8c6a535c9f1f17f0f
      002 7020a0183e17a7233e665b979c78c184ea369cfaf3e8b4b11f5547ecb7c13c53
      003 51df5a9192fdefe0ddca4bdf290932f74be03ffd0503a3d112e4199905e718b2
      004 ad080a30a4ac6c1273373617f29628cc320a35c8cd06913894794293dc52c8b3
      005 221e4b725b770ad0bb6924df3f8d04f89eeca4558f6e4c777dfa93e967090529
      006 6a8e2e2a6180d0f1ce39dcd651622fb6d2fd05db7c459f64ae42d667f1e344b8
      007 de1ccc07b7bfc9e25243ad854f3bbb5d3ebf9155b0477df16aaf00a7b0d5edaf
      008 86144700465933636d7b945e89b77df95d3620034725be161ca0ca5a42e239ba
      009 0b6bdd1a18a0d20e330cc3bc71e048864e4a13652e29dc0ebf3918bea729343c
      010 8465c6f2c56afe559402265b39d9e94368954930f9aa7f3dfa6d36dd66868e06
      011 dd56426ef7d7295e1107c0b3d06c192eb9298f4023c202ca2ba6266c613d170d
      012 fac271d2bf6372c9903e3b353cb9eda044d7fe36b5aab52f21f3f21cd6a2063e
      013 1b25efacbc1c4683b886d065b7a089a3601964555bcbf11f3a58989d38e853b6
      014 a7f75cedb43c5845ab1c60afade22dcb5e5dc12dd98c0f5a3abcfb9f309bb17c
      015 d37602ecbeb62d5a22c8167ea1e621fcdbaaa79925890a973a45c810dd01c326
      016 501f91cc89fadced16c73aa8858796651473602c722bb29f86a8ba588d0ff1b1
      017 773f90b98768d4662a22470ea8eec5fdd8e3439f370f94638872aaf884bcd270
      018 5bc494b42f719a8b0d844b7bd9ad50ebaae560e97f67c833c9e7e9d53981a8cc
      019 27170d6edfe8819835407fdc08b401d2e161b1400fe9d0c5317a51104c89c11e
      020 1840e2cbf26ba822913662f74037594ed562361485390c52813b38156c99522c
      021 bd8f59054a763ec1c64179ad5cb607f558708a317c2bdb22b814e3da456374c1
      022 45331f0936e36ab91bfe44b936e33ed8a1b1848fa896e8a1d0f2ef74f297cb79
      023 4fec236f3fbd3d0c47b893fdfa9122142a474f6ef66c20ffb6c0f4864dd591b6
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://gnu.cu.be/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    sha256 "146666182c1443133ee6aa3a6f4ed35867dae4cb431f78e2ffb6e9faaf2d7394" => :mojave
    sha256 "de0293a18d1208a80444f5d1b0a33c44b7f328ba8e07214646e3405b5c1bb95f" => :high_sierra
    sha256 "d58a520a0ca3be4eb5c61d0bd9779c8ecf780d52b4b235043f048545717c9e33" => :sierra
    sha256 "291b5db2cc18c491f4a9e210bb2e61afa76632aac65a8dc4eec935e6cb475bd9" => :el_capitan
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
