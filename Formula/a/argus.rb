class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "https://openargus.org"
  url "https://github.com/openargus/argus/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "d2ac1013832ba502570ce4a152c02c898e3725b8682e21af54d8e3a513c3396e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "42ddc1e03a084a0e68b4e0acce8078bc28d85d17b6e234fa6b523c67e30c374f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd66bf50cf9c6dd402c58e531708893cd2aca10266d6d2d70ecb00768775ac27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dff8faed6dd67b53ab7bfdba11cc52385e32c675d2610dee21eb0bdecc3d0c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7626939126bc907b343cc0782fbb87bcb05928e2147f3314c2e4f77d8df21548"
    sha256 cellar: :any_skip_relocation, sonoma:         "68c8c71f306e9f13d030a81c69a6f0325b57b9b06c3d8ea6ee1037bc75fca757"
    sha256 cellar: :any_skip_relocation, ventura:        "a358ec3026dbb2b9c0f8dc6800a97c608859993a5bc46d129d9c668fb174c785"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9b325392bbd2b9838141d04dcb2f145599fa55f4f5dc4d75e83d26baac2261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b66d1d53a26ee4246fb31053f0ce4cddea6a54b27529cd0cdbf852942ccdd51"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["libtirpc"].opt_include}/tirpc"
      ENV.append "LIBS", "-ltirpc"
    end
    system "./configure", "--with-sasl", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Pages", shell_output(bin/"argus-vmstat") if OS.mac?
    assert_match "Argus Version #{version}", shell_output("#{sbin}/argus -h", 255)
    system sbin/"argus", "-r", test_fixtures("test.pcap"), "-w", testpath/"test.argus"
    assert_predicate testpath/"test.argus", :exist?
  end
end
