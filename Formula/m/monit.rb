class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.34.0.tar.gz"
  sha256 "37f514cd8973bbce104cb8517ff3fc504052a083703eee0d0e873db26b919820"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9b961058b5f02a9c80808f4ad56432f029d061f508a5d93c4302fd3b5109e47a"
    sha256 cellar: :any,                 arm64_ventura:  "a8eacf89a5adc75d1958d4400aa1a0a82bf9f1abd87ddc967c5a8da51894423b"
    sha256 cellar: :any,                 arm64_monterey: "86f677767c4d8f53000bafc3508285c3960bfa31189ff2144c787407c3be2d08"
    sha256 cellar: :any,                 sonoma:         "c64f092092a97afafbc4afa84a49a6757dbbed54b4fc9b05505a52af54f6ed2f"
    sha256 cellar: :any,                 ventura:        "28b4ac7d86d9913774a0c49b873dece3c5e4903be7891ca64adc4bc1c53ee923"
    sha256 cellar: :any,                 monterey:       "38a80a517adb3ff706b4bc51045d301b8602c3c57cde443aa8cea22299b4021d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89e69dcd7d9b2665ac42593b2d72a33cbaac505cf07dcdf33223c09c4b59f7b2"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
