class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.085.1.tar.gz"
    sha256 "2aeb6e3f200da2ee6a2dc184339be7e216996c1c533cf8998398b7122fec15cb"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.085.1.tar.gz"
      sha256 "8863398ff9b90579309a9d89919ee32d9edead0f1b7a78afabb310523aec4d61"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.085.1.tar.gz"
      sha256 "bd5ea0441b36f222aa16551f4a059dc0904ba2329da3eca11f30e9017991e51f"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.085.1.tar.gz"
      sha256 "0fd812a76f02cdeab7e18438b19b1126514ea4f3bce058f632f49e424709010e"
    end
  end

  bottle do
    sha256 "df7903a57d8f47c295c917ccc44bfedccaeb4a675fe2fcb8fd490af9ea843171" => :mojave
    sha256 "a2fc2767e47a88b91900dd528160be1e97ae644b656dc070fc7331223d711c63" => :high_sierra
    sha256 "cb31ea70dee9799f930351ee5a4ecc7f323efd38f2a4ddc0ad5d7e6c1f4dab1f" => :sierra
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

  def install
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
