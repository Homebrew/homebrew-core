class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "20fa97e507d067e9e2ab0c1accfc334f5a4b10d01312e55455dc3733748585f4"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbeb1ac7f62d885b1da78d5dd696aba5a64419b633a4632bd697a86bdf75296f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a1cabdf23d90daf3eb90b93255ff789ecc82799ab22eed6abf649e6eeb404b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "165e17e92ff42b8c44c227ed26347fc9c91d178d51f059756980af066c1ca23c"
    sha256 cellar: :any_skip_relocation, ventura:        "265f8a37577dac9e432aae815243499794c458c6b33a58c5a73769f13e600a98"
    sha256 cellar: :any_skip_relocation, monterey:       "5c33a21581e4041b8a53e0b5ea8b52d8eff4f070694294578af5cf2d01b8a64a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aa32ff2ea64217b303a7634842c9d43049bfe6525e779c6c7d058e63fa67ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea05e8a8cf47639e53aa33adcb3b65d7e111fe468f7e58971de30421cd89611"
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
