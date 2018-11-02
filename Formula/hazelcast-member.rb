class HazelcastMember < Formula
  desc "Command-line tool to run and control Hazelcast member instances"
  homepage "https://github.com/hazelcast/hazelcast-member-tool"
  url "https://github.com/hazelcast/hazelcast-member-tool/releases/download/v3.11.0/hazelcast-member-3.11.0.tar.gz"
  sha256 "13d9d8f9c608ea8f672e58dba87500ff38c2c70d1f69e1f3cf30532a9be67056"

  bottle :unneeded

  depends_on "coreutils"
  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    (etc/"hazelcast").install_symlink "#{libexec}/etc/hazelcast/hazelcast.xml"
    bin.install_symlink Dir["#{libexec}/bin/hazelcast-member"]
    var.mkpath
    inreplace "#{libexec}/bin/utils.sh", "${var}", var.to_s
    inreplace "#{libexec}/bin/utils.sh", "${etc}", etc.to_s
    prefix.install_metafiles
    bash_completion.install "#{libexec}/bin/hazelcast-member-completion.sh" => "hazelcast-member"
  end

  test do
    begin
      output = shell_output("#{bin}/hazelcast-member start --verbose -J -Dhazelcast.http.healthcheck.enabled=true")
      assert_match /ID:/, output
      sleep 5
      output = shell_output("#{bin}/hazelcast-member status")
      assert_match /Running/, output

      assert_match /Hazelcast::NodeState=ACTIVE/, shell_output("curl -s http://127.0.0.1:5701/hazelcast/health")
      output = shell_output("#{bin}/hazelcast-member stop")
      assert_match /shut down/, output
    ensure
      quiet_system "pkill", "-9", "-f", "hazelcast"
    end
  end
end
