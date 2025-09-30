class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "https://openargus.org"
  url "https://github.com/openargus/argus/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "1718454ac717fe5f500d00ff608097e3c5483f4e138aa789e67e306feb52bafb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e54dcb3c0b96387252e93801d6cad6152fb3a0864d9379a253070aca6b0d8469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "347acb963caee49f75d34625c31ea0d62da3a7197cdce61877ea7a9cc4234a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df1ed0d1ca211cc64e1d53368628178ba4b184e7b13f34734dfd8da167008dd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7fb76b9b7256db647ea6a124882c3cfee5e0838b08cca59494f53ce295caac1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee799b219fbfca3ff8c1babf20c550ab30274e3fa2e87f964a53a3a47416d65c"
    sha256 cellar: :any_skip_relocation, ventura:       "a48764b6fbf43defc9dfa3505f6bc5e53c683eb2a94a5a05575fb31c16305695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "466b334735a7bca04ea37ec2c5e1fdaccaa651c75c59fbbc57cad68709dae99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f955db69cd767d836e4f1c784f21d22205f3f7ed466218f1837ea89743e3a8c1"
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
    assert_path_exists testpath/"test.argus"
  end
end
