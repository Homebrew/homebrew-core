class Davmail < Formula
  desc "POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway"
  homepage "https://davmail.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/6.0.0/davmail-6.0.0-3375.zip"
  version "6.0.0"
  sha256 "272cd4853fb4adc986318bd859933aa49ccdc1c59f457039a48ae0fbc0977f47"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e77d76802b26f7a255a559ff31051b1d5d31cb50d3bac39d2ca964a33f8da11"
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
