class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.34.2.tar.gz"
  sha256 "291ca3d898e9b425b6d0c1768728fecd6c1cf4c268c79db15fda26285ad5b832"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b91e194ede0be9a2584b3bd74f990554f7c4f3c13909ad96d2820c2533349eac"
    sha256 cellar: :any,                 arm64_sonoma:  "43e8978a21db2203454c7a0b35d251e6afc78b947b48b0375b1905911ba8e9b5"
    sha256 cellar: :any,                 arm64_ventura: "c47816dd7ca0feddd533a116461cd1142cc1cd0a3e15898dc6daf2757d967d66"
    sha256 cellar: :any,                 sonoma:        "e948b9050bb2f6586341e6bf94c20a8c9d66afbeea0e0673830a2e44286bd6a0"
    sha256 cellar: :any,                 ventura:       "73c91c695045ef18b460914ca1e2fc4f37a7ea52abe6ec01736f259c9b79b220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19b0d3a596836603972a16747d01f522c0b242c30e919511205d2427fc12859"
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
