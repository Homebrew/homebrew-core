class PostgresXc < Formula
  desc "PostgreSQL cluster based on shared-nothing architecture"
  homepage "https://sourceforge.net/p/postgres-xc/xc-wiki/Main_Page/"
  url "https://downloads.sourceforge.net/project/postgres-xc/Version_1.0/pgxc-v1.0.4.tar.gz"
  sha256 "b467cbb7d562a8545645182958efd1608799ed4e04a9c3906211878d477b29c1"
  revision 1

  bottle do
    rebuild 1
    sha256 "0b41238976c5eb1c1998845aacdc98d4c5d22adc96a0ff264efb1c55318e1925" => :mojave
    sha256 "fa227de1722867aadf57d0868bc137a67f30d79b613fbf713396ba846b33f908" => :high_sierra
    sha256 "9219ea92a221cae45f87c8119afbae22a190c396f41972ab2f8019ede381207d" => :sierra
    sha256 "8c17e52f8c1171e0a4e36d77180ee5113aa61d35acbe0d11741372d3fe93e9f5" => :el_capitan
    sha256 "3dc1e2e4d10cc1cf2604b5bc91c4167257bd84b27a167580d2342e7ab7539428" => :yosemite
  end

  depends_on :arch => :x86_64
  depends_on "openssl"
  depends_on "ossp-uuid"
  depends_on "readline"

  conflicts_with "postgresql",
    :because => "postgres-xc and postgresql install the same binaries."

  fails_with :clang do
    build 211
    cause "Miscompilation resulting in segfault on queries"
  end

  # Fix PL/Python build: https://github.com/Homebrew/homebrew/issues/11162
  patch :DATA

  def install
    # Fix uuid-ossp build issues: https://www.postgresql.org/message-id/05843630-E25D-442A-A6B0-5CA63622A400@likeness.com
    ENV.append_to_cflags "-D_XOPEN_SOURCE"
    # See https://sourceforge.net/p/postgres-xc/mailman/postgres-xc-bugs/thread/82E44F89-543A-44F2-8AF8-F6909B5DC561@uniud.it/
    ENV.append "CFLAGS", "-D_FORTIFY_SOURCE=0 -O2" if MacOS.version >= :mavericks

    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include} -I#{Formula["readline"].opt_include}"

    ENV.append "CFLAGS", `uuid-config --cflags`.strip
    ENV.append "LDFLAGS", `uuid-config --ldflags`.strip
    ENV.append "LIBS", `uuid-config --libs`.strip

    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
      "--datadir=#{pkgshare}",
      "--docdir=#{doc}",
      "--enable-thread-safety",
      "--with-bonjour",
      "--with-gssapi",
      "--with-krb5",
      "--with-libxml",
      "--with-libxslt",
      "--with-openssl",
      "--with-ossp-uuid",
      "ARCHFLAGS=-arch x86_64",
    ]

    system "./configure", *args

    # Building the documentation looks for Jade or OpenJade, neither of which exist on macOS
    # or are supplied by Homebrew at this point in time. Disable for now, since error fatal.
    inreplace "GNUmakefile", "recurse,install-world,doc-xc src", "recurse,install-world,src"
    system "make", "install-world"

    plist_path("gtm").write gtm_startup_plist("gtm")
    plist_path("gtm").chmod 0644
    plist_path("gtm_proxy").write gtm_proxy_startup_plist("gtm_proxy")
    plist_path("gtm_proxy").chmod 0644
    plist_path("coord").write coordinator_startup_plist("coord")
    plist_path("coord").chmod 0644
    plist_path("datanode").write datanode_startup_plist("datanode")
    plist_path("datanode").chmod 0644
  end

  def post_install
    (var/"postgres-xc").mkpath
  end

  def caveats; <<~EOS
    To get started with Postgres-XC, read the documents at
      https://sourceforge.net/projects/postgres-xc/files/Publication/
      https://postgres-xc.sourceforge.io/docs/1_0/tutorial-start.html

    For a first cluster, you may start with a single GTM (Global Transaction Manager),
    a pair of Data Nodes and a single Coordinator, all on the same machine:

      initgtm -Z gtm -D #{var}/postgres-xc/gtm
      initdb -D #{var}/postgres-xc/datanode1 --nodename datanode1
      initdb -D #{var}/postgres-xc/datanode2 --nodename datanode2
      initdb -D #{var}/postgres-xc/coord --nodename coord

    Then edit:

      #{var}/postgres-xc/datanode1/postgresql.conf
      #{var}/postgres-xc/datanode2/postgresql.conf

    and change the port to 15432 and 15433, respectively.

    Then, launch the nodes and connect to the coordinator:

      gtm -D #{var}/postgres-xc/gtm -l #{var}/postgres-xc/gtm/server.log &
      postgres -i -X -D #{var}/postgres-xc/datanode1 -r #{var}/postgres-xc/datanode1/server.log &
      postgres -i -X -D #{var}/postgres-xc/datanode2 -r #{var}/postgres-xc/datanode2/server.log &
      postgres -i -C -D #{var}/postgres-xc/coord -r #{var}/postgres-xc/coord/server.log &
      psql postgres
        create node datanode1 with (type='datanode', port=15432);
        create node datanode2 with (type='datanode', port=15433);
        select * from pgxc_node;
        select pgxc_pool_reload();

    To shutdown everything, kill the processes in reverse order:

      kill -SIGTERM `head -1 #{var}/postgres-xc/coord/postmaster.pid`
      kill -SIGTERM `head -1 #{var}/postgres-xc/datanode1/postmaster.pid`
      kill -SIGTERM `head -1 #{var}/postgres-xc/datanode2/postmaster.pid`
      kill -SIGTERM `head -1 #{var}/postgres-xc/gtm/gtm.pid`

    If you get the following error:
      FATAL:  could not create shared memory segment: Cannot allocate memory
    then you need to tweak your system's shared memory parameters:
      https://www.postgresql.org/docs/current/static/kernel-resources.html#SYSVIPC
  EOS
  end

  plist_options :startup => true

  # Override Formula#plist_name
  def plist_name(extra = nil)
    extra ? super()+"-"+extra : super()+"-gtm"
  end

  # Override Formula#plist_path
  def plist_path(extra = nil)
    extra ? super().dirname+(plist_name(extra)+".plist") : super()
  end

  def gtm_startup_plist(name); <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/gtm</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-l</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
  EOS
  end

  def gtm_proxy_startup_plist(name); <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/gtm_proxy</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-n</string>
        <string>2</string>
        <string>-s</string>
        <string>localhost</string>
        <string>-t</string>
        <string>6666</string>
        <string>-l</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
  EOS
  end

  def coordinator_startup_plist(name); <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/postgres</string>
        <string>-i</string>
        <string>-C</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-r</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
  EOS
  end

  def datanode_startup_plist(name); <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/postgres</string>
        <string>-i</string>
        <string>-X</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-r</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/initdb", "--nodename=brew", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end


__END__
--- a/src/pl/plpython/Makefile	2011-09-23 08:03:52.000000000 +1000
+++ b/src/pl/plpython/Makefile	2011-10-26 21:43:40.000000000 +1100
@@ -24,8 +24,6 @@
 # Darwin (OS X) has its own ideas about how to do this.
 ifeq ($(PORTNAME), darwin)
 shared_libpython = yes
-override python_libspec = -framework Python
-override python_additional_libs =
 endif

 # If we don't have a shared library and the platform doesn't allow it
