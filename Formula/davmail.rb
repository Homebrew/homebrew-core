class Davmail < Formula
  desc "POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway"
  homepage "https://davmail.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/6.0.1/davmail-6.0.1-3390.zip"
  version "6.0.1"
  sha256 "40ad06e29e5040fa2eebbc21bafcc61ce807db53cbd116fd3d8f31fada0c3fc4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d08699043b36822e5063281967f3f5625079e53144a7336cc2a0bd38dd46796a"
  end

  depends_on "openjdk"

  uses_from_macos "netcat" => :test

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
    log_path "/dev/null"
    error_log_path "/dev/null"
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

    fork do
      exec bin/"davmail", testpath/"davmail.properties"
    end

    sleep 10

    system "nc", "-z", "localhost", caldav_port
    system "nc", "-z", "localhost", imap_port
    system "nc", "-z", "localhost", ldap_port
    system "nc", "-z", "localhost", pop_port
    system "nc", "-z", "localhost", smtp_port
  end
end
