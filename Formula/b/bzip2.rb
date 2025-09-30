class Bzip2 < Formula
  desc "Freely available high-quality data compressor"
  homepage "https://sourceware.org/bzip2/"
  url "https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz"
  sha256 "ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269"
  license "bzip2-1.0.6"

  livecheck do
    url "https://sourceware.org/pub/bzip2/"
    regex(/href=.*?bzip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e823d1ae6f9409cd524669dfe94dd9922e5661998be5ae416b237aa4713c8d54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dddec821ca1677a0b509f565a4ad1e28d8df8ce8e26e48aa2efb7d2c37cf5d12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f148a0cf9cec0d1711b5bd16c18047e0a9933acec37bfec30a182f29ae364577"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52f70f97b2f8f2c6bc309e55970ed03ccd1b8110cf5f15fc16c2a930180a99f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcc8f2e728b154d43e76e8e81f77e934d905b8868b7be69e3b9b40b5868f7c34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12f184d77bb72cc7d9278af9bd34fd74c610f7aa144559e2aa2d9f4a4b09bd76"
    sha256 cellar: :any_skip_relocation, sonoma:         "0aa9de4f40daf644d2c5745e35a20fac2babda8df0218e58bd471d0132ba8457"
    sha256 cellar: :any_skip_relocation, ventura:        "2cf2591f8865d9a806736a6f1b74f0905477b5520dd730f025aa12d4c5e0749b"
    sha256 cellar: :any_skip_relocation, monterey:       "fc4dd056738e20b1c850c6834405e27071a992f7671137306c1764c7c0eef350"
    sha256 cellar: :any_skip_relocation, big_sur:        "d222e089bf7b4ab714b150ad754cb76b88b548f57c4bdbbaa4857d6e0541a096"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3a85918b5e50c5e958e9a322630a2acab61aa4ac8857ab70c7967eeedded42e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a731afa70daaafec28359b4f10f1c68455c1955ae66cdbb6b6d52eee277bbd3e"
  end

  keg_only :provided_by_macos

  def install
    inreplace "Makefile", "$(PREFIX)/man", "$(PREFIX)/share/man"

    system "make", "install", "PREFIX=#{prefix}"
    return if OS.mac?

    # Install shared libraries
    system "make", "-f", "Makefile-libbz2_so", "clean"
    system "make", "-f", "Makefile-libbz2_so"
    lib.install "libbz2.so.#{version}", "libbz2.so.#{version.major_minor}"
    lib.install_symlink "libbz2.so.#{version}" => "libbz2.so.#{version.major}"
    lib.install_symlink "libbz2.so.#{version}" => "libbz2.so"

    # Create pkgconfig file based on 1.1.x repository.
    # https://gitlab.com/bzip2/bzip2/-/blob/master/bzip2.pc.in
    (lib/"pkgconfig/bzip2.pc").write <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      bindir=${exec_prefix}/bin
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include

      Name: bzip2
      Description: Lossless, block-sorting data compression
      Version: #{version}
      Libs: -L${libdir} -lbz2
      Cflags: -I${includedir}
    EOS
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz2"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip2", testfilepath
    system bin/"bunzip2", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
