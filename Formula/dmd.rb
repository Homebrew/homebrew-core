class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.100.0.tar.gz"
    sha256 "77d8623f614ab2a41c17ee86e84880021836051553dd7f09f3f6eee8e024c55d"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.100.0.tar.gz"
      sha256 "b9622c94468326487380393d183790830f38d224bb5d15067b6e4f5ec9cfced4"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.100.0.tar.gz"
      sha256 "cebf9fecdaf395bdb745cbed990879e561d055cc367ba44ba69fb40ab9c45008"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.100.0.tar.gz"
      sha256 "7b53e32606b22acc391dd2a4e7c8527fabc18045ade3f99b3d38e8fa471066c8"
    end
  end

  bottle do
    sha256 monterey:     "34bc7d0e41d87c9c8354ab99663316411bf26c58bf0d8b098be658a7b50db8b0"
    sha256 big_sur:      "c1a41ca96898f331ef32ae2f38d849538b5bd349301d39bb9722f2e18cbc3ea7"
    sha256 catalina:     "5c075add4b5c34a65290624f81aadf2a56d48e8c1c6f4d2c4d46f39f20121549"
    sha256 x86_64_linux: "f5b58266a065e6a097a90789e50b0d92ae7920fc62deaf31174dfe9b0716d6db"
  end

  head do
    url "https://github.com/dlang/dmd.git", branch: "master"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git", branch: "master"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git", branch: "master"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git", branch: "master"
    end
  end

  depends_on "ldc" => :build
  depends_on arch: :x86_64

  def install
    dmd_make_args = %W[
      INSTALL_DIR=#{prefix}
      SYSCONFDIR=#{etc}
      HOST_DMD=#{Formula["ldc"].opt_bin/"ldmd2"}
      ENABLE_RELEASE=1
      VERBOSE=1
    ]

    system "ldc2", "src/build.d", "-of=src/build"
    system "src/build", *dmd_make_args

    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      DMD_DIR=#{buildpath}
      DRUNTIME_PATH=#{buildpath}/druntime
      PHOBOS_PATH=#{buildpath}/phobos
      -f posix.mak
    ]

    (buildpath/"druntime").install resource("druntime")
    system "make", "-C", "druntime", *make_args

    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    kernel_name = OS.mac? ? "osx" : OS.kernel_name.downcase
    bin.install "generated/#{kernel_name}/release/64/dmd"
    pkgshare.install "samples"
    man.install Dir["docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/**/libdruntime.*", "phobos/**/libphobos2.*"]

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
