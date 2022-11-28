class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "8eddcbeae191a58d2d2a19305ed0a60776e43999eb29b64536566ba24506a6c1"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5faaebd07083a0f13d538596dcee302039489d3677bc837958fd0f21a450a17f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfabdc1e29b3b0e943d45ad93d160707c35fc6398ad62836f261e6cdfbf236d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6653fd2894604d8cdbc0de8f25b57a6a08627ea279877896996ec3d86f41ff71"
    sha256 cellar: :any_skip_relocation, monterey:       "2aef87fe3a98aea435ce8f0c1d27e4c50ce6183be352a8775185ac95eacf062f"
    sha256 cellar: :any_skip_relocation, big_sur:        "48c8302a7a0477e03bb130eee6d41cc03885b7b0fbfe03e9f106db12b266e6d9"
    sha256 cellar: :any_skip_relocation, catalina:       "44fff805e39b53f35575bd530213d20850ed5b48838da778899c7a0aa8b31797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d547b94f44390455338331435e6deca5f81bedc4473de9b65e63e8618ef7e69"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf"
  depends_on "thrift"

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_TESTING=OFF",
                    "-DWITH_ELASTICSEARCH=ON",
                    "-DWITH_EXAMPLES=OFF",
                    "-DWITH_JAEGER=ON",
                    "-DWITH_LOGS_PREVIEW=ON",
                    "-DWITH_METRICS_PREVIEW=ON",
                    "-DWITH_OTLP=ON",
                    "-DWITH_OTLP_GRPC=ON",
                    "-DWITH_OTLP_HTTP=ON",
                    "-DWITH_PROMETHEUS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include "opentelemetry/sdk/trace/simple_processor.h"
      #include "opentelemetry/sdk/trace/tracer_provider.h"
      #include "opentelemetry/trace/provider.h"
      #include "opentelemetry/exporters/ostream/span_exporter.h"
      #include "opentelemetry/exporters/otlp/otlp_recordable_utils.h"

      namespace trace_api = opentelemetry::trace;
      namespace trace_sdk = opentelemetry::sdk::trace;
      namespace nostd     = opentelemetry::nostd;

      int main()
      {
        auto exporter = std::unique_ptr<trace_sdk::SpanExporter>(
            new opentelemetry::exporter::trace::OStreamSpanExporter);
        auto processor = std::unique_ptr<trace_sdk::SpanProcessor>(
            new trace_sdk::SimpleSpanProcessor(std::move(exporter)));
        auto provider = nostd::shared_ptr<trace_api::TracerProvider>(
            new trace_sdk::TracerProvider(std::move(processor)));

        // Set the global trace provider
        trace_api::Provider::SetTracerProvider(provider);

        auto tracer = provider->GetTracer("library", OPENTELEMETRY_SDK_VERSION);
        auto scoped_span = trace_api::Scope(tracer->StartSpan("test"));
      }
    EOS
    system ENV.cxx, "test.cc", "-std=c++11", "-I#{include}", "-L#{lib}",
           "-lopentelemetry_resources",
           "-lopentelemetry_trace",
           "-lopentelemetry_exporter_ostream_span",
           "-lopentelemetry_common",
           "-pthread",
           "-o", "simple-example"
    system "./simple-example"
  end
end
