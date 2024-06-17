class Davmail < Formula
  desc "POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway"
  homepage "https://davmail.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/6.2.2/davmail-6.2.2-3546.zip"
  version "6.2.2"
  sha256 "e39a5a1b2e927d41572babd8f0be2d1c56228a8d7fe5a87dbd3c86226760c072"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/davmail/rss?path=/davmail"
    regex(%r{url=.*?/davmail[._-]v?(\d+(?:\.\d+)+)(?:-\d+)?\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c55c26e3679337482c014409c4fec1ba607af4e644a47063c3d81785f30bf3b0"
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
