class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-6.0.0.tar.gz"
  sha256 "ddacd2a8120aeb2351e4486ee04a17782b5004aee99f2041d829bc4dcf2a5b3b"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ca2ec2602bad5c37d7b07954d966e8834124cd97600637dc7cdfdd82a850ef0"
    sha256 cellar: :any, arm64_sequoia: "7c43581cc73b89a8de2e4b91a708e03dc843e2c873e6ebcf3d2214b04f34d6de"
    sha256 cellar: :any, arm64_sonoma:  "1d0f9ab36c0c7f938a2ce25115d3922fca0297dda200da36ab3f5f3f84c2db87"
    sha256 cellar: :any, sonoma:        "0badbc8e5be8a3069c5e31ad24f49c85c94bc36d381b68d6c632cb188432406a"
    sha256 cellar: :any, arm64_linux:   "60e2478b3b8c7cabfaf2f00142e6c13d50ce31afb292db7166fe66a2460d936d"
    sha256 cellar: :any, x86_64_linux:  "e8077e05324760fa6f9992c2917945b71cbf301452a7f553addd08b1163347c9"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{formula_opt_prefix("openssl@3")}"
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
