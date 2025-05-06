class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.35.1.tar.gz"
  sha256 "77a4c023ee06aeed48536dfeb49d96a868a9eb8106c3e2e88cab537bbc72951b"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "267d802f49e409571e2c3f4dcea3f80ae0ff0b8ca1cb0434b3eef3019d2d21e0"
    sha256 cellar: :any,                 arm64_sonoma:  "cdd44f47ce9a6eec587db269e145f2d84b02ccf09775d10e7b19d8400c739c5c"
    sha256 cellar: :any,                 arm64_ventura: "a6f6f1030d61dbafec5ad9ef03860a4f3c94c572a108d65bca4fa5b0ceab85fb"
    sha256 cellar: :any,                 sonoma:        "08b92db5cbc402ddbf0a4dfd43433fe0642856fc4549f71ae18d57e0f9712243"
    sha256 cellar: :any,                 ventura:       "81ec35e09d7bf59fdc26330bc4364fadc4e0c8f718e41b6177718a544b54f0f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "931204ad21f2cc42ab0dce03b2b4ce2a1cfef74ab5e30dc4536a657389d0270f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071eabbcc839d19fd3d4b4f69cb98b9af4b2a696c65021a8b7d43b984aaafba4"
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
