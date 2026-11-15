class Davmail < Formula
  desc "POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway"
  homepage "https://davmail.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/7.1.0/davmail-7.1.0-4498.zip"
  version "7.1.0"
  sha256 "c007d3ac57e00d680c977c1b2d027d70ca7713dd734f69423ccd4bcb11c0cf54"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/davmail/rss?path=/davmail"
    regex(%r{url=.*?/davmail[._-]v?(\d+(?:\.\d+)+)(?:-\d+)?\.(?:t|zip)}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c38ab83a35580e004cc1f5c7d30cfe89125a997bd0ed54057976e3bf342ae3b3"
  end

  depends_on "openjdk"

  uses_from_macos "netcat" => :test

  allow_network_access! :test

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"davmail.jar", "davmail", "-Djava.awt.headless=true"
  end

  service do
    run opt_bin/"davmail"
    run_type :interval
    interval 300
    keep_alive false
    environment_variables PATH: std_service_path_env
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    caldav_port = free_port
    imap_port = free_port
    ldap_port = free_port
    pop_port = free_port
    smtp_port = free_port

    (testpath/"davmail.properties").write <<~EOS
      davmail.server=true
      davmail.mode=auto
      davmail.url=https://example.com

      davmail.caldavPort=#{caldav_port}
      davmail.imapPort=#{imap_port}
      davmail.ldapPort=#{ldap_port}
      davmail.popPort=#{pop_port}
      davmail.smtpPort=#{smtp_port}
    EOS

    spawn bin/"davmail", testpath/"davmail.properties"
    sleep 10

    system "nc", "-z", "localhost", caldav_port
    system "nc", "-z", "localhost", imap_port
    system "nc", "-z", "localhost", ldap_port
    system "nc", "-z", "localhost", pop_port
    system "nc", "-z", "localhost", smtp_port
  end
end
