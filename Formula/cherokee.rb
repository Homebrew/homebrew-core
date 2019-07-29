class Cherokee < Formula
  desc "Modern, user friendly web server"
  homepage "http://cherokee-project.com/"
  url "https://src.fedoraproject.org/repo/pkgs/cherokee/cherokee-1.2.103.tar.gz/527b3de97ef9727bfd5f6832043cf916/cherokee-1.2.103.tar.gz"
  sha256 "790777e7b4355b60698443161e45b5a20a9d0ab8c4c47924e00d19da8b74dfcd"

  bottle do
    sha256 "f582bd9e3157068f8d8c996cffa803a256ec70e356473b96ba8856b3f20f9ccd" => :mojave
    sha256 "e149e2a50f0954be520def65943abf020f44460ceeb41d428627c5d65be2d177" => :high_sierra
    sha256 "db0adb2f4e099777e5309d1b2ca2102c8ae576eb45a51c827f0e2fb7866b66ed" => :sierra
    sha256 "f6944776619d9338169b1676cc10d9960c27cb7a88b1189a4e02e1f577d4e2d6" => :el_capitan
    sha256 "af00f0cc177c2c16063aa3abe8dfe025568874db126edfacce4a33c8a3fbd5cb" => :yosemite
    sha256 "ef4d94b51cc425dd704d0007cf9980024035406cb00345158fd84b1901c04437" => :mavericks
  end

  depends_on "gettext"
  depends_on "openssl"

  # OS X 10.9 patch
  patch do
    url "https://github.com/cherokee/webserver/commit/d0213768fdc6cf3aee61fe0be398d7825c01198f.diff?full_index=1"
    sha256 "dc4c678e55b906a5a1437f93789232a6eb016e80214e92b0032f50c68ae2997b"
  end

  def install
    if build.head?
      ENV["LIBTOOL"] = "glibtool"
      ENV["LIBTOOLIZE"] = "glibtoolize"
      cmd = "./autogen.sh"
    else
      cmd = "./configure"
    end

    system cmd, "--disable-dependency-tracking",
                "--prefix=#{prefix}",
                "--sysconfdir=#{etc}",
                "--localstatedir=#{var}/cherokee",
                "--with-wwwuser=#{ENV["USER"]}",
                "--with-wwwgroup=www",
                "--enable-internal-pcre",
                # Don't install to /Library
                "--with-wwwroot=#{etc}/cherokee/htdocs",
                "--with-cgiroot=#{etc}/cherokee/cgi-bin"
    system "make", "install"

    prefix.install "org.cherokee.webserver.plist"
    (prefix+"org.cherokee.webserver.plist").chmod 0644
    (pkgshare/"admin/server.py").chmod 0755
  end

  def caveats
    <<~EOS
      Cherokee is setup to run with your user permissions as part of the
      www group on port 80. This can be changed in the cherokee-admin
      but be aware the new user will need permissions to write to:
        #{var}/cherokee
      for logging and runtime files.

      By default, documents will be served out of:
        #{etc}/cherokee/htdocs

      And CGI scripts from:
        #{etc}/cherokee/cgi-bin

       If this is your first install, automatically load on startup with:
          sudo cp #{prefix}/org.cherokee.webserver.plist /Library/LaunchDaemons
          sudo launchctl load -w /Library/LaunchDaemons/org.cherokee.webserver.plist

      If this is an upgrade and you already have the plist loaded:
          sudo launchctl unload -w /Library/LaunchDaemons/org.cherokee.webserver.plist
          sudo cp #{prefix}/org.cherokee.webserver.plist /Library/LaunchDaemons
          sudo launchctl load -w /Library/LaunchDaemons/org.cherokee.webserver.plist
    EOS
  end

  test do
    assert_match "Version: #{version}", shell_output("#{sbin}/cherokee -i")
  end
end
