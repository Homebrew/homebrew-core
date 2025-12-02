class Libusbmuxd < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libusbmuxd/releases/download/2.1.1/libusbmuxd-2.1.1.tar.bz2"
  sha256 "5546f1aba1c3d1812c2b47d976312d00547d1044b84b6a461323c621f396efce"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be1c5b8ab89996815b0c7b39a613396665cc3946a15edcac5c0d39dc099c5aa7"
    sha256 cellar: :any,                 arm64_sequoia: "f8255f91e52d9854b2aec30297e8038c2154ff3cb59f64b0cc8006cb301f143c"
    sha256 cellar: :any,                 arm64_sonoma:  "b3dfe62a2e25c35da59e32db101d490974d93a1a6ed30755bb4380a7d947a63e"
    sha256 cellar: :any,                 arm64_ventura: "da3ade8614bf17b6d7415bcaca5d567c78e72e0c170e2f0bb386a77169964a23"
    sha256 cellar: :any,                 sonoma:        "f20787b876fc3b9c8412d92ac2adaeb3dc2526155d327b0118534bb06c208079"
    sha256 cellar: :any,                 ventura:       "eff1c068df54d65b5fc16bfee3aa8f6a556574c4ccbb3d9c56ee91efd12c639a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ec20326419ca71e8bb1d5b0fbc545f9b9028592a16f257e55ab6bc02772296b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2a58d873fa065eb1e3940d7f45f4f16781a90dd188f880368d50aac172a850"
  end

  head do
    url "https://github.com/libimobiledevice/libusbmuxd.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libimobiledevice-glue"
  depends_on "libplist"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    source = free_port
    dest = free_port

    PTY.spawn(bin/"iproxy", "-s", "localhost", "#{source}:#{dest}") do |r, w, pid|
      assert_match "Creating listening port #{source} for device port #{dest}", r.readline
      assert_match "waiting for connection", r.readline
      TCPSocket.new("localhost", source).close
      assert_match "New connection for #{source}->#{dest}", r.readline
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
  end
end
