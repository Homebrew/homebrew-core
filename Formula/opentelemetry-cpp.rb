class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3d640201594b07f08dade9cd1017bd0b59674daca26223b560b9bb6bf56264c2"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b98c9e00d2ffeeba947d348c8a54e91eb24f7a8dde5ba2fad68e0b7140630b26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d46860b60e02d5a5713da2c5d0dae9d59d102c425890b8da8d6f3fca2200d4d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a9b28601f0f3ab9d8305a1d6b52519fd19e4bfcb763583a1b0d01e8dc0f5e5a"
    sha256 cellar: :any_skip_relocation, ventura:        "7e9082cc2ae26aede607faec328c1c14958ff8824d3108a805304d984ee53b17"
    sha256 cellar: :any_skip_relocation, monterey:       "372f3e6122a52d8df5556dd44f5fb6306b8d04f035310501c0d6733f119310ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "faf0f34c5992a03ea7d7136bc48bae31ac3b829ae240d35cbd9c87c094d59dcf"
    sha256 cellar: :any_skip_relocation, catalina:       "6dcac4098af40ddb983e2243cfe6fd430d023c99fc0004c383d6e609c5755e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6086e5d1710fe73fb8652f73fd191b934877962c52f30345d3c0c54c9c6ad10f"
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
