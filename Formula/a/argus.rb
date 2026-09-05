class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "https://openargus.org"
  url "https://github.com/openargus/argus/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "9c3863fd44fd2912dd763002fbe733259564b00b9b7c66b2e9b970bf2a41232d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a03777617d9463528bbcbcde53fb41c7e71714d3cbea88a8e879867d414457a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33c4cd6f9ccac086d5188f7129c2f18f34067a04fbd180dcf75965fc987fe0f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb10a12ad665abbac41da441f9befcc2c2ad07decba71626d98dcb7e37a5b3f6"
    sha256 cellar: :any,                 arm64_linux:   "1057d398b7a18fade04635a46dfbe15d9d102bee9ffe0aef67c727fa209bdc38"
    sha256 cellar: :any,                 x86_64_linux:  "9760a0bff8b21d1a0e537cf3fa3c3f8cb08ceab7ae2386da088715ef4b61baee"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "libtirpc"
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{formula_opt_include("libtirpc")}/tirpc"
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
    assert_path_exists testpath/"test.argus"
  end
end
