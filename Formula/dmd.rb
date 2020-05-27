class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.092.0.tar.gz"
    sha256 "e21b7d20c2251fb5c8a77d573f1f3ee5038c6a719bd3902c019d616e2e8e7f72"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.092.0.tar.gz"
      sha256 "a33dbd54439bac4fda0f8c6de3ff54787a456fcea66dae64c91415d151e7e3df"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.092.0.tar.gz"
      sha256 "e7e6529ae79e088ce2e1b79793151d15b8b1f80221c50dfa8ecafc149bd8cc31"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.092.0.tar.gz"
      sha256 "169891c348bc282b570ed84ef8b26683c7dc0c04e391132fecef96dcfa23042d"
    end
  end

  bottle do
    sha256 "2a3d60bb722c8a2222d639802d9daca2f23967a5d3dc52d0908b3c7b01d400a3" => :catalina
    sha256 "cd1eb63007da7a74a50fe48a76c05b1c78eec3016fee6be3dd6ecb4851e86776" => :mojave
    sha256 "4771a5b877c70c8eb7089681eb26e8f86cb7c2e94a934a4eb46c7cbd228e1075" => :high_sierra
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  uses_from_macos "unzip" => :build
  uses_from_macos "xz" => :build

  def install
    # DMD defaults to v2.088.0 to bootstrap as of DMD 2.090.0
    # On MacOS Catalina, a version < 2.087.1 would not work due to TLS related symbols missing

    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      -f posix.mak
    ]

    dmd_make_args = %W[
      SYSCONFDIR=#{etc}
      TARGET_CPU=X86
      AUTO_BOOTSTRAP=1
      ENABLE_RELEASE=1
    ]

    system "make", *dmd_make_args, *make_args

    make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"

    (buildpath/"druntime").install resource("druntime")
    system "make", "-C", "druntime", *make_args

    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    bin.install "generated/osx/release/64/dmd"
    pkgshare.install "samples"
    man.install Dir["docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    (buildpath/"dmd.conf").write <<~EOS
      [Environment]
      DFLAGS=-I#{opt_include}/dlang/dmd -L-L#{opt_lib}
    EOS
    etc.install "dmd.conf"
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", pkgshare/"samples/hello.d"
    system "./hello"
  end
end
