class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.25.0.tar.gz"
  sha256 "5d43f7e75f6197b6cee305bee27b9a41af80a2a17416dbd3b04c538898b88b83"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

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
    sha256 arm64_sequoia: "93ebb9d05d50ee73b9a596c732d93810734155ea7f5889ed6bec14a6cf9bd158"
    sha256 arm64_sonoma:  "9f6fab1d37d4dcc579c085b85a62aae9fa6f0ace3492ad3457213db9aaa2c326"
    sha256 arm64_ventura: "515f6ff9b8088c289c9884b222fed773e859c001da5b246848156abd80955682"
    sha256 sonoma:        "3a5f4caf4491c5d7bd9b52a741a668159bac45b2e305a3bce1715f093c2b1848"
    sha256 ventura:       "3a50ed243032041f7104fb32a151e9e2a1111df187bb6f3f2c9c07ef5e718a7f"
    sha256 arm64_linux:   "05bc03b878665ed9b7438ff23945518a1e4521ffe05509de5f04e29e274b8c9f"
    sha256 x86_64_linux:  "51c514abe7c902c1acfb373e3dd028d1786c8877f2b20d77b13618571c117de8"
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
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.25.0.tar.gz"
    sha256 "bbc69bb2d9924feaaeac19ccc1b280a92f010a011b5925ade0357b96ce0074d9"

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
