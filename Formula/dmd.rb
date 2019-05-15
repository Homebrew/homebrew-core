class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.086.0.tar.gz"
    sha256 "a76658bfcb4eaf82d532a09762f084ee1f07c292bd3b64ecfa115ccffb986630"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.086.0.tar.gz"
      sha256 "64f6f6ac62fcb43ef615bce8e056439aaa837b5b4b74a878f84f3a9a2999297a"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.086.0.tar.gz"
      sha256 "492e7679c20bbbcc5021107b98ca68390030f942b007114e453263b1553e0d48"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.086.0.tar.gz"
      sha256 "2bde2f0195aa3323f8743f5bb1000dad76db75833b5a7d8096698d2007f71bb6"
    end
  end

  bottle do
    sha256 "518598accfc5f7423920d42d488fb89c6b78a0781f434a1e23cbbc2c93b38796" => :mojave
    sha256 "2621e448f360c890121eb549a56a9aa31b408bdda6d28f09a057bf71f6668c56" => :high_sierra
    sha256 "6089321f5381aa6396767897c4272162df28620b67320dbe01c6faae88dd06a9" => :sierra
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
