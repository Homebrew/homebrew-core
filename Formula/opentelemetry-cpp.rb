class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  # TODO: Check if we can use unversioned `grpc` and `protobuf` at version bump.
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "668de24f81c8d36d75092ad9dcb02a97cd41473adbe72485ece05e336db48249"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17809590a134d0817ddf64dffdefc888f0fc9d4f846de6a066687da64121f8f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74f3dc5b76f35ffdd91bc27f5726e6969c1a3170a26be689c17b95d2a2db62a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95b029bb2986e7ac7bd6e4d50d3d55cc3cf1fbeee3b23b4b4251b2b5e6fffb9a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e1dcc6a778ab5c2491ca7c1341d836f9ed6608b814b9b25b09ea0f2126ae2dd"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e4bfb297d5a69f04bdd1702cb7918dd51741b98ecb6113ed7c099c74c14ad9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba36165ed9a192966ab3590d071d1f14092d156bc7910bd53be4eee01a00569a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c2c26b235cd609c780a3ac804d53379d78e97c44820993f4b5cdae74de4a37"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "grpc@1.54"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf@21"
  uses_from_macos "curl"

  def install
    ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup" if OS.mac?
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # Keep in sync with C++ standard in abseil.rb
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_TESTING=OFF",
                    "-DWITH_ELASTICSEARCH=ON",
                    "-DWITH_EXAMPLES=OFF",
                    "-DWITH_JAEGER=OFF", # deprecated, needs older `thrift`
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
    # Manual `protobuf` include can be removed when we depend on unversioned protobuf.
    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{include}", "-L#{lib}",
                    "-I#{Formula["protobuf@21"].opt_include}",
                    "-lopentelemetry_resources",
                    "-lopentelemetry_exporter_ostream_span",
                    "-lopentelemetry_trace",
                    "-lopentelemetry_common",
                    "-pthread",
                    "-o", "simple-example"
    system "./simple-example"
  end
end
