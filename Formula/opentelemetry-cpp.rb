class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "20fa97e507d067e9e2ab0c1accfc334f5a4b10d01312e55455dc3733748585f4"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba378e447d2be33d7966a1aefa42ccfc1299bf51e7e10258a14035f576c03b7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fad81bc0a03420a9269122db23709133157a07ef8ba0987f2a3931a0c3feda6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "592e5aabb6a100cd5586482e283487d3248b23365a9eb9ebc15a3aba41970afb"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d68e6e3c1c654c4d95e6ccb935fd5e81cc40e784747e73f2a4064ccd6284e9"
    sha256 cellar: :any_skip_relocation, monterey:       "686f48590ecb7a0c79c7fa71464e22973c4e4b9f86da9ed46ce21dd7f016ec2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "66b27de1d743a740c528687c4f6a4625422af27d463234ab95df99c791485c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd5b6950475d36a9562921c9700ad9a4ea7300f662458a59580babca3ab172b4"
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
