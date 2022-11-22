class GambitScheme < Formula
  desc "Implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "fb202eb0660fcfbf84dfdf80bb37dd16ed94da6d24898a336441cdd58573ccd0"
    sha256 arm64_monterey: "91040b009cdde2f167bff43b1521c1bae3b402c28bfe57a1d9fdc603b6e7eeee"
    sha256 arm64_big_sur:  "9abbafcba2c1205b675204642a58527262586625b99a2ae8a32d3b50076a87ef"
    sha256 ventura:        "f8babf62d122b3f057798a10b9df2688db1994b7e99c68e9d28c17aa7527cb54"
    sha256 monterey:       "eaeab4965a7dc4b0bdeb880287af96157c4fb666897db2a1f23772b80837bc7f"
    sha256 big_sur:        "88dfbed920720584cea9ac1500cc59a7d6df69532e38728314594466bdf8a7a8"
    sha256 catalina:       "cc4d0841423822b27fd424f7eba3a0482f01266ef61c25ec4b1d49d211d6c50e"
    sha256 mojave:         "9fc086d950cb20c99d1d24947a0599fab72525c8a2dbd2d448f94791a5a8f481"
    sha256 high_sierra:    "8af81a5c228d029402bc150331cb03dc0695eeee8dd5a58ce497a7a49a19fa47"
    sha256 x86_64_linux:   "279db92ba64c71c31bf9a57df2414b0b47f497b47fd1c7a2fc39657be3b47db4"
  end

  depends_on "openssl@1.1"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-openssl
    ]

    system "./configure", *args

    # Fixed in gambit HEAD, but they haven't cut a release
    inreplace "config.status" do |s|
      s.gsub! %r{/usr/local/opt/openssl(?!@1\.1)}, "/usr/local/opt/openssl@1.1"
    end
    system "./config.status"

    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_equal "0123456789",
      shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
