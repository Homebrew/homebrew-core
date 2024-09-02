class Ldb < Formula
  desc "LDAP-like embedded database"
  homepage "https://ldb.samba.org"
  url "https://download.samba.org/pub/ldb/ldb-2.9.1.tar.gz"
  sha256 "c95e4dc32dea8864b79899ee340c9fdf28b486f464bbc38ba99151a08b493f9b"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://download.samba.org/pub/ldb/"
    regex(/href=.*?ldb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "efbfa53d3984f5c1b9bcdc4210f5932f324b9a569cd91d1ffa43b9862f41b28d"
    sha256 arm64_ventura:  "f8058e25e3d54f1d6d73c7f89bec08d76c08f4394743cb939a1628d7dd0b7fdd"
    sha256 arm64_monterey: "20528d2bc32e76953b834f66f1ef0c351ba45ecf1b3e0d86ba6d0640d7ad142e"
    sha256 sonoma:         "709111956c5b6d5747eb68735e291c3ebd79b8bf4cb4759a9e1df4a2777f5b06"
    sha256 ventura:        "aecdbd299198a616acbff3eacfc7ac07b49642bf4a415834418498ac65c76cc1"
    sha256 monterey:       "c17f63379fc41b715cafea0139877798f78694d992b7ad049ebf65768037a8f4"
    sha256 x86_64_linux:   "051ee3eb49899d308b429254c6585057e49e2d4e0ab1cf2ffbe7e77cecf513be"
  end

  depends_on "cmocka" => :build
  depends_on "pkg-config" => :build
  depends_on "lmdb"
  depends_on "popt"
  depends_on "talloc"
  depends_on "tdb"
  depends_on "tevent"

  uses_from_macos "python" => :build

  conflicts_with "samba",
    because: "both install `ldbadd`, `ldbdel`, `ldbedit`, `ldbmodify`, `ldbrename`, `ldbsearch` binaries"

  def install
    args = %W[
      --bundled-libraries=NONE
      --disable-python
      --disable-rpath
      --prefix=#{prefix}
    ]
    # Work around undefined symbol "_rep_strtoull"
    args += ["--builtin-libraries=", "--disable-rpath-private-install"] if OS.mac?

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test-default-config.ldif").write <<~EOS
      dn: cn=Global,cn=DefaultConfig,cn=Samba
      objectclass: globalconfig
      Workgroup: WORKGROUP
      UnixCharset: UTF8
      Security: user
      NetbiosName: blu
      GuestAccount: nobody

      dn: cn=_default_,cn=Shares,cn=DefaultConfig,cn=Samba
      objectclass: fileshare
      cn: _default_
      Path: /tmp
      ReadOnly: yes
    EOS

    ENV["LDB_URL"] = "test.ldb"
    assert_equal "Added 2 records successfully", shell_output("#{bin}/ldbadd test-default-config.ldif").chomp
    assert_match "returned 1 records", shell_output("#{bin}/ldbsearch '(Path=/tmp)'")
    assert_equal "Modified 1 records successfully", pipe_output("#{bin}/ldbmodify", <<~EOS, 0).chomp
      dn: cn=_default_,cn=Shares,cn=DefaultConfig,cn=Samba
      changetype: modify
      replace: Path
      Path: /temp
    EOS
    assert_match "returned 0 records", shell_output("#{bin}/ldbsearch '(Path=/tmp)'")
    assert_match "returned 1 records", shell_output("#{bin}/ldbsearch '(Path=/temp)'")
  end
end
