class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.27.1.tar.gz"
  sha256 "878e52c4a6cc3bd28048b527a920fba86ce4cd99c5760adc42417a811efa6e6b"
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
    sha256 arm64_tahoe:   "29412bea49edc3fbb2e160d22c7dfd6c8866df16b9f46ecd0129dc43eaab3fac"
    sha256 arm64_sequoia: "6e18292b7ac5b41666abe42288ec8a24b6a9952b16bfe30a61e2611fb3ba7c1e"
    sha256 arm64_sonoma:  "15ef8978868387f70161e2bb6561483488c5c33e6907014ce64405a96ed9a9c7"
    sha256 sonoma:        "a58882d37579d43c27caa1e06b520cd01aabc6e753fb010f28468ceddc8d0bdc"
    sha256 arm64_linux:   "8c060b069c1fe108000ed9f32a036d82b7627e7f48e7bb0d82f13b6a0611fbd0"
    sha256 x86_64_linux:  "d1ba434bbaf98fc82972132138ed8cbfb1171db1929fa3b6d93dfdd1019a9f25"
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
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.27.1.tar.gz"
    sha256 "fd32c1255c0114d55929b496a15a6a6f48231f108be23f50ad3b8abc2e734ccf"

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
