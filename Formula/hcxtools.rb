class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.7.tar.gz"
  sha256 "c9d69b5ddcf61c3deff687fad6c17197970cc75c5dbc7706b31c138bf0c784e1"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8185ea5bf24763e28884679562966c84985056eebb4dbb69ff1e022c91ffabf6"
    sha256 cellar: :any,                 arm64_monterey: "6156b1ef29b02fdadfbdc54f71b3a078b96d3d8b9796dbd04718867dd8b00456"
    sha256 cellar: :any,                 arm64_big_sur:  "186091dc51a382aa1333327948c39332ee2f27d486c2f1fc53078ffbd4ea3310"
    sha256 cellar: :any,                 ventura:        "eb789fb97c96d8317a35b641c9aa81ac1b894667f32a6ffc8c25f76c19c49e9e"
    sha256 cellar: :any,                 monterey:       "5904fbf23939d2088b281db6b7b57644489b56abc853359e5d7816c5d58de976"
    sha256 cellar: :any,                 big_sur:        "5958acc14ba6fdf7f0caf618ebf8df79adfea1f25fd639010691e9540aea4304"
    sha256 cellar: :any,                 catalina:       "52b1f37012a6a76b4cdecc0bfb8675fdb1ce04119d8910602121f0727fdf7dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b34c7c93cbe7fe057686b5c46a68b91d7a618d413d1052ff61acd422d869686"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

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
