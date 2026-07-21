class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.28.0.tar.gz"
  sha256 "03722ab589c00b4e823ee22eb0afef5611b82e4f764fccc37ad3b18a3732c49e"
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
    sha256 arm64_tahoe:   "154c060b7fcd7ed487b6e2e8f58af6cc1ca81334f546579e45b273c1a6680140"
    sha256 arm64_sequoia: "4ad15e1ad7532ad7c52d27584ad5ed459381b585d62f90554297d55146c7cb9a"
    sha256 arm64_sonoma:  "16307ea57719fa7677365d75cfd98f957d458ed83e611ce4d3ab1f0dd025a2bf"
    sha256 sonoma:        "89635917980c1fe090f1d36ad33a8d6a7e33817dec514714a5180dd7c4eab755"
    sha256 arm64_linux:   "732453e8f736bfd354579b01e65065dc7dc9e4cfa2efd2d06e8ded9d9afdf0db"
    sha256 x86_64_linux:  "1facd055a632f3948294b974e5e74c12c29b6c62dec1c454a9e614b6924034e1"
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
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.28.0.tar.gz"
    sha256 "e044ce5926491e649f96c943482bf56bc268389fcb5d2edc4bcc4e94ceff09aa"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "masterfiles resource needs to be updated" if version != resource("masterfiles").version

    args = %W[
      --with-workdir=#{var}/cfengine
      --with-lmdb=#{formula_opt_prefix("lmdb")}
      --with-pcre2=#{formula_opt_prefix("pcre2")}
      --without-mysql
      --without-postgresql
    ]

    args << "--with-systemd-service=no" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  post_install_steps do
    set_permissions %w[cfengine/inputs cfengine/outputs cfengine/ppkeys cfengine/plugins], "0700",
                    recursive: false
    set_permissions "cfengine/state", "0750", recursive: false
    set_permissions "cfengine/modules", "0755", recursive: false
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
