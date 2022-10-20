class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.7.tar.gz"
  sha256 "c9d69b5ddcf61c3deff687fad6c17197970cc75c5dbc7706b31c138bf0c784e1"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "24d06b03f444b8d96ababeded338616a4f2dcf9e319156f42eb320dd71ce0f81"
    sha256 cellar: :any,                 arm64_big_sur:  "6401a756aebf675ade6eb471c579b1841d8658b660d38b7f4bc84b279dcd5275"
    sha256 cellar: :any,                 monterey:       "f147def903c38e1f5e58e00b997a60c41e9856a0bbd347c6ba3e3630049e96dc"
    sha256 cellar: :any,                 big_sur:        "d2926410fd310dfdba03ff7f21fb56582ed65cc199a7952c3981f1db6120192d"
    sha256 cellar: :any,                 catalina:       "724c4e3cdc4026c84c7c9de3d8972917fad385c585bd4da5259ab09bfc7e7646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22950fbb1c486d3886f90c45dabefcb9239d9322681fba91f4fe7fe5009a6b3"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Create file with 22000 hash line
    testhash = testpath/"test.22000"
    (testpath/"test.22000").write <<~EOS
      WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***
    EOS

    # Convert hash to .cap file
    testcap = testpath/"test.cap"
    system "#{bin}/hcxhash2cap", "--pmkid-eapol=#{testhash}", "-c", testpath/"test.cap"

    # Convert .cap file back to hash file
    newhash = testpath/"new.22000"
    system "#{bin}/hcxpcapngtool", "-o", newhash, testcap

    # Diff old and new hash file to check if they are identical
    system "diff", newhash, testhash
  end
end
