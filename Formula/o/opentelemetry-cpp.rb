class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "ba782ab583d943d2d4002ee354b9775fe2647c4a4906462db237d2733ff66df6"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a0cc78692c330edfd93164fdf4d6b68f0cb35e665c9bc5c0d093df1b7bf4fea"
    sha256 cellar: :any,                 arm64_ventura:  "b39821c787c09045ce0e1a1ae508d7e1477fd5f23cae2012c540792f8b4abfb1"
    sha256 cellar: :any,                 arm64_monterey: "7df92d3f1e8866f18f566e22d0cf29160e7dc2300af6d87e4e29453c0fc0dd9f"
    sha256 cellar: :any,                 sonoma:         "5ef824a91274323c7078783283797aa59dd1966f3fb6c64b88a908325d8b6b59"
    sha256 cellar: :any,                 ventura:        "fc501e0fed3be145d1c83a2a90e8120c1e555569411ef235c34f24cc6b8a535b"
    sha256 cellar: :any,                 monterey:       "eea003c2c99e6f369efbe0de620be7e28108c1039bca856542d2071d60fc4e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e302fd7d74eb4c587114aba04ab5092cb7608012e15b7132b64362f0fdb946"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf"
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
                    "-DWITH_METRICS_PREVIEW=ON",
                    "-DWITH_OTLP_GRPC=ON",
                    "-DWITH_OTLP_HTTP=ON",
                    "-DWITH_ABSEIL=ON",
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

        auto tracer = provider->GetTracer("foo_library", "1.0.0");
        auto scoped_span = trace_api::Scope(tracer->StartSpan("test"));
      }
    EOS
    system ENV.cxx, "test.cc", "-std=c++17",
                    "-DHAVE_ABSEIL",
                    "-I#{include}", "-L#{lib}",
                    "-lopentelemetry_resources",
                    "-lopentelemetry_exporter_ostream_span",
                    "-lopentelemetry_trace",
                    "-lopentelemetry_common",
                    "-pthread",
                    "-o", "simple-example"
    system "./simple-example"
  end
end
