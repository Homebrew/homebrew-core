class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.075.1.tar.gz"
    sha256 "98f3851c744b5cece97821aa371b7e690f7dfa1086b929385ae79e567664e89e"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.075.1.tar.gz"
      sha256 "5635347bff625522d50707352588d8e43d53618486f5322cc69100e97f4d2d3f"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.075.1.tar.gz"
      sha256 "94ba75e996904e890889b1bbe73eb8ba7dca5982cb3c6574ae7cad26384fa87c"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.075.1.tar.gz"
      sha256 "ba3ea0925f05b0a5d730c13f0ceae4000942157ae78e1afc4c214d55b9cbc60c"
    end
  end

  bottle do
    sha256 "fd47cfa377ebfd60efa81f3055cea91739ba6f5d919071a388c3099c7e147db4" => :sierra
    sha256 "ca36760d6dade06bb0a3f338982ce84df1245ff287c2d3cbade7224bdd60d61a" => :el_capitan
    sha256 "48df5506973862c14a85a7fb1da6f12b335da3abe977851a98047974ad4a278e" => :yosemite
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
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    if build.head?
      make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"
      (buildpath/"druntime").install resource("druntime")
      (buildpath/"phobos").install resource("phobos")
      system "make", "-C", "druntime", *make_args
      system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

      resource("tools").stage do
        inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
        system "make", "install", *make_args
      end

      (include/"dlang/dmd").install Dir["druntime/import/*"]
      cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
      lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

      conf = buildpath/"dmd.conf"
      # Can't use opt_include or opt_lib here because dmd won't have been
      # linked into opt by the time this build runs:
      conf.write <<-EOS.undent
          [Environment]
          DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
          EOS
      etc.install conf
    else
      # A proper dmd.conf is required for later build steps:
      conf = buildpath/"dmd.conf"
      # Can't use opt_include or opt_lib here because dmd won't have been
      # linked into opt by the time this build runs:
      conf.write <<-EOS.undent
          [Environment]
          DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
          EOS
      etc.install conf
      install_new_dmd_conf

      make_args.unshift "DMD=#{bin}/dmd"

      (buildpath/"druntime").install resource("druntime")
      (buildpath/"phobos").install resource("phobos")

      system "make", "-C", "druntime", *make_args
      system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

      (include/"dlang/dmd").install Dir["druntime/import/*"]
      cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
      lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

      resource("tools").stage do
        inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
        system "make", "install", *make_args
      end
    end
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  # This must be idempotent because it may run from both install() and
  # post_install() if the user is running `brew install --build-from-source`.
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
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
