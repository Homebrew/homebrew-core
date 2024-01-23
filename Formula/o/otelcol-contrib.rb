class OtelcolContrib < Formula
  desc "OpenTelemetry Collector (contrib distribution)"
  homepage "https://opentelemetry.io/docs/collector/"
  url "https://github.com/open-telemetry/opentelemetry-collector-releases/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "1d1337870014a2e06e2edebf9381448fe0841758148e620a6e934cfbb3618e55"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-collector-releases.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["distributions"] = "otelcol-contrib"
    system "make", "build"
    bin.install "distributions/otelcol-contrib/_build/otelcol-contrib" => "otelcol-contrib"
  end

  test do
    require "net/http"

    (testpath/"config.yaml").write <<~EOF
      receivers:
        otlp:
          protocols:
            http:
      exporters:
        logging:
          verbosity: detailed
      service:
        pipelines:
          metrics:
            receivers: [otlp]
            exporters: [logging]
    EOF

    fork do
      exec "#{bin}/otelcol-contrib", "--config", (testpath/"config.yaml")
    end

    sleep 10

    resp = Net::HTTP.post(URI("http://127.0.0.1:4318/v1/metrics"), "{}", {
      "Content-Type": "application/json",
    })
    assert_equal true, (resp.is_a? Net::HTTPSuccess),
      "HTTP request to OpenTelemetry Collector should succeed"
    assert_equal "{\"partialSuccess\":{}}", resp.body,
      "HTTP request to OpenTelemetry Collector should return a partial success"
  end
end
