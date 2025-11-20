class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.26.0.tar.gz"
  sha256 "d3c3884b314dae48a6884e919d0a12acac5aea95d970544e4632a1773857d19b"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]
  revision 1

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    strategy :json do |json|
      json["releases"]&.map do |release|
        next if release["beta"] || release["debug"]

        release["version"]
      end
    end
  end

  bottle do
    sha256 arm64_tahoe:   "194b3201f5b814761facbd866c90ec628022d8725eb2f86a577468f310c48611"
    sha256 arm64_sequoia: "d6076844084c19870cdae5aaac4214a2f71e07255b97e82c68d95f540b9f2e12"
    sha256 arm64_sonoma:  "1994f0d7654e3078812d7e5920d9b07cc22b34c94c4079804cffdd5bcf21754f"
    sha256 sonoma:        "85eb2b22b230823f8c0efc0d6694ed0a70389bda905f4d49fa789798d213dd44"
    sha256 arm64_linux:   "8f689a3cb668ca26e7a4a4867c87902c859f047ae189468183a667c867379101"
    sha256 x86_64_linux:  "eafd202ffd88f9364ca84f3431740a23f75350bbae158de2fa3252df1f6f7eae"
  end

  depends_on "librsync"
  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "curl", since: :ventura # uses CURLOPT_PROTOCOLS_STR, available since curl 7.85.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.26.0.tar.gz"
    sha256 "fc8b0ad20e803e0d1e9dcda7afb2f3f5110357ac0e553ed95cf2cbea9652451d"

    livecheck do
      formula :parent
    end
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
