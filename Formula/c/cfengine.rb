class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.24.0.tar.gz"
  sha256 "5bda099d7db16dc33fee137ca8768dd9544e3c345e803289c3576bb8e2c99391"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_sequoia:  "20779dbdb8303205db16531ef9ddfb7f2fdbcfbbc54091cd413f769b84687de0"
    sha256 arm64_sonoma:   "18719079eb21bc965564edc3b4bd68cf3efab30ed315b03a5aae9fd85d1f466f"
    sha256 arm64_ventura:  "119f1b3f3a22031fb2d4e3c642cc07b359f671b195759ddcdb6eb2eb40006c43"
    sha256 arm64_monterey: "9aa1cd2fb9135ebc8ebd5c2f4b0c7ca3d759d4879ba209c08cdf3ce0137940ef"
    sha256 sonoma:         "270fd431b6fad619d4d3184668ce7af7490710936ae42e6f52ea6b55fd6e70a1"
    sha256 ventura:        "dfa881b76a8944a39d8f0b65740ff9a300c22106cdd586f69d25002d0fb40fc0"
    sha256 monterey:       "c729c653b85d0470709964c2d400105182519556e885e90456000d705811c081"
    sha256 x86_64_linux:   "191903064ba2fd218876311949c1f555f95f9e11874681021eccfbae1d8e94be"
  end

  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "curl", since: :ventura # uses CURLOPT_PROTOCOLS_STR, available since curl 7.85.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.24.0.tar.gz"
    sha256 "0611c3137cc3142d46b45055ea4473b1c115593d013ebe02121bd7304bc7ab79"
  end

  def install
    odie "masterfiles resource needs to be updated" if version != resource("masterfiles").version

    args = %W[
      --with-workdir=#{var}/cfengine
      --with-lmdb=#{Formula["lmdb"].opt_prefix}
      --with-pcre2=#{Formula["pcre2"].opt_prefix}
      --without-mysql
      --without-postgresql
    ]

    args << "--with-systemd-service=no" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  def post_install
    workdir = var/"cfengine"
    secure_dirs = %W[
      #{workdir}/inputs
      #{workdir}/outputs
      #{workdir}/ppkeys
      #{workdir}/plugins
    ]
    chmod 0700, secure_dirs
    chmod 0750, workdir/"state"
    chmod 0755, workdir/"modules"
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
