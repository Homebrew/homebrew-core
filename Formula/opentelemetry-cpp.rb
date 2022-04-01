class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  stable do
    url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "7a6420f9e4fa44b81a5b06e30e5e116da71decc9086e5cc4f126e1efc8a397c2"

    # cmake install misses a header open-telemetry/opentelemetry-cpp#1273
    patch do
      url "https://github.com/open-telemetry/opentelemetry-cpp/commit/e072daa229f72431b1c50986645d51180a586d09.patch?full_index=1"
      sha256 "ce54f49532f81e6bc984d8e2e2436d96be1abd2f819f42029168f45aa7b068ed"
    end
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
                    "-DWITH_EXAMPLES=OFF",
                    "-DWITH_JAEGER=ON",
                    "-DWITH_LOGS_PREVIEW=ON",
                    "-DWITH_METRICS_PREVIEW=ON",
                    "-DWITH_OTLP_GRPC=ON",
                    "-DWITH_OTLP_HTTP=ON",
                    "-DWITH_OTLP=ON",
                    "-DWITH_PROMETHEUS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "opentelemetry/sdk/trace/simple_processor.h"
      #include "opentelemetry/sdk/trace/tracer_provider.h"
      #include "opentelemetry/trace/provider.h"
      #include "opentelemetry/exporters/ostream/span_exporter.h"

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
      }
    EOS
    system ENV.cxx, "test.c", "-std=c++11", "-I#{include}", "-L#{lib}",
           "-lopentelemetry_resources",
           "-lopentelemetry_trace",
           "-lopentelemetry_exporter_ostream_span",
           "-lopentelemetry_common",
           "-pthread",
           "-o", "simple-example"
    system "./simple-example"
  end
end
