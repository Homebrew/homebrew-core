class CephClient < Formula
  desc "Rados and RBD CLIs and libraries of the Ceph project"
  homepage "https://ceph.com"
  url "git@github.com:ceph/ceph.git", :using => :git, :tag => "v13.2.1", :revision => "5533ecdc0fda920179d7ad84e0aa65a127b20d77"
  version "mimic-13.2.1"

  depends_on python if MacOS.version <= :snow_leopard

  depends_on :osxfuse
  depends_on "openssl" => :build
  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "leveldb" => :build
  depends_on "nss"
  depends_on "pkg-config" => :build
  depends_on "yasm"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["nss"].opt_lib}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl"].opt_lib}/pkgconfig"
    system "./do_cmake.sh",
              "-DCMAKE_CXX_COMPILER=clang++",
              "-DCMAKE_C_COMPILER=clang",
              "-DWITH_EMBEDDED=OFF",
              "-DWITH_MANPAGE=ON",
              "-DWITH_LIBCEPHFS=OFF",
              "-DWITH_XFS=OFF",
              "-DWITH_KRBD=OFF",
              "-DWITH_LTTNG=OFF",
              "-DCMAKE_BUILD_TYPE=Debug",
              "-DWITH_CCACHE=ON",
              "-DWITH_RADOSGW=OFF",
              "-DWITH_CEPHFS=OFF",
              "-DDIAGNOSTICS_COLOR=always",
              "-DWITH_SYSTEMD=OFF",
              "-DWITH_RDMA=OFF",
              "-DWITH_BABELTRACE=OFF",
              "-DWITH_BLUESTORE=OFF",
              "-DWITH_SPDK=OFF",
              "-DWITH_LZ4=OFF",
              "-DOPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include"
    system "make", "--directory=build", "rados", "rbd", "ceph-fuse", "manpages"
    MachO.open("build/bin/rados").linked_dylibs.each do |dylib|
      if not dylib.start_with?("/tmp/")
        next
      end
      MachO::Tools.change_install_name("build/bin/rados", dylib, "#{lib}/#{dylib.split('/')[-1]}")
    end
    MachO.open("build/bin/rbd").linked_dylibs.each do |dylib|
      if not dylib.start_with?("/tmp/")
        next
      end
      MachO::Tools.change_install_name("build/bin/rbd", dylib, "#{lib}/#{dylib.split('/')[-1]}")
    end
    MachO.open("build/bin/ceph-fuse").linked_dylibs.each do |dylib|
      if not dylib.start_with?("/tmp/")
        next
      end
      MachO::Tools.change_install_name("build/bin/ceph-fuse", dylib, "#{lib}/#{dylib.split('/')[-1]}")
    end
    bin.install "build/bin/ceph"
    bin.install "build/bin/ceph-fuse"
    bin.install "build/bin/rados"
    bin.install "build/bin/rbd"
    lib.install "build/lib/libceph-common.0.dylib"
    lib.install "build/lib/libceph-common.dylib"
    lib.install "build/lib/librados.2.0.0.dylib"
    lib.install "build/lib/librados.2.dylib"
    lib.install "build/lib/librados.dylib"
    lib.install "build/lib/libradosstriper.1.0.0.dylib"
    lib.install "build/lib/libradosstriper.1.dylib"
    lib.install "build/lib/libradosstriper.dylib"
    lib.install "build/lib/librbd.1.12.0.dylib"
    lib.install "build/lib/librbd.1.dylib"
    lib.install "build/lib/librbd.dylib"
    man8.install "build/doc/man/ceph-conf.8"
    man8.install "build/doc/man/ceph.8"
    man8.install "build/doc/man/librados-config.8"
    man8.install "build/doc/man/rados.8"
    man8.install "build/doc/man/rbd-fuse.8"
    man8.install "build/doc/man/rbd-ggate.8"
    man8.install "build/doc/man/rbd-mirror.8"
    man8.install "build/doc/man/rbd-nbd.8"
    man8.install "build/doc/man/rbd-replay-many.8"
    man8.install "build/doc/man/rbd-replay-prep.8"
    man8.install "build/doc/man/rbd-replay.8"
    man8.install "build/doc/man/rbd.8"
    man8.install "build/doc/man/rbdmap.8"
    ENV.prepend_create_path "PYTHONPATH", libexec
    libexec.install "src/pybind/ceph_argparse.py"
    libexec.install "src/pybind/ceph_daemon.py"
    libexec.install "src/pybind/ceph_volume_client.py"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/ceph", "--version"
    system "#{bin}/ceph-fuse", "--version"
    system "#{bin}/rbd", "--version"
    system "#{bin}/rados", "--version"
  end
end
