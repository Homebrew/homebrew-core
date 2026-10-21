class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.28.0.tar.gz"
  sha256 "03722ab589c00b4e823ee22eb0afef5611b82e4f764fccc37ad3b18a3732c49e"
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
    sha256 arm64_golden_gate: "aabd414cf300c8f8c0bb77c2284f838dcb08157159cf305c493c039de0143b25"
    sha256 arm64_tahoe:       "5ca7354bb409f4a4368201c7238c3d57240484a2c52c338e4d0ebb9bd9737748"
    sha256 arm64_sequoia:     "f10f8f15a6557e3c4dfad57819b2ef710b0d4c06c2079f423172c0a614f8eef6"
    sha256 arm64_linux:       "af13e68cbae6695514beb559976b4698f19941f2466486ec6c850468f341478d"
    sha256 x86_64_linux:      "761bf6e3cee2da013a822e892fe5793951828cab86506d7e8e2d9b6b253d65cd"
  end

  depends_on "librsync"
  depends_on "lmdb"
  depends_on "openssl@4"
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
                    recursive: false, base: :var
    set_permissions "cfengine/state", "0750", recursive: false, base: :var
    set_permissions "cfengine/modules", "0755", recursive: false, base: :var
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
