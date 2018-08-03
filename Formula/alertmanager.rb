class Alertmanager < Formula
  desc "Prometheus Alertmanager"
  homepage "https://prometheus.io/docs/alerting/alertmanager/"
  url "https://github.com/prometheus/alertmanager/archive/v0.15.1.tar.gz"
  sha256 "5b36c873b25443b61cc0686e048596737c9d11a3579c39ef9063b3c619595da8"

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/alertmanager"

    system "make", "build"
    bin.install %w[alertmanager amtool]
  end

  test do
    (testpath/"config.yml").write <<~EOS
      global:
        # The smarthost and SMTP sender used for mail notifications.
        smtp_smarthost: 'localhost:25'
        smtp_from: 'alertmanager@example.org'
        smtp_auth_username: 'alertmanager'
        smtp_auth_password: 'password'

      # The root route on which each incoming alert enters.
      route:
      # A default receiver
        receiver: team-X-mails

      receivers:
      - name: 'team-X-mails'
        email_configs:
        - to: 'team-X+alerts@example.org'
    EOS
    system "#{bin}/amtool", "check-config", testpath/"config.yml"
  end
end
