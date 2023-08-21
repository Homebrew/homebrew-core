class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  # TODO: Check if we can use unversioned `grpc` and `protobuf` at version bump.
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "19e8ade04a674c8cf7f0dc6da1f7b0583a27d2cf4dbc03df87894a16a4547834"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "de744b63cdd56736dc5009b45226b95d1b92777746c1694e2074ef3d296be357"
    sha256 cellar: :any,                 arm64_monterey: "ce39b15daeaa4d969237e6cebc8a08e7db522132b2a37f845253b407363910eb"
    sha256 cellar: :any,                 arm64_big_sur:  "01e3bbe7ddb28bb37c8eb63c062e7e4e14511cffeb6e7eacc03a574389d91b19"
    sha256 cellar: :any,                 ventura:        "c774edb06f689c87c3234ec83fd207d04c3ba548604c0ecdda07ec94d1d99189"
    sha256 cellar: :any,                 monterey:       "8b348e4c0f7b23200c1e95609152c91f5abcff35dcff53f4575026ddb24d3793"
    sha256 cellar: :any,                 big_sur:        "0abfc2f525e2494e29389b6d497a830388334d41803df822c5c1515631c6a26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71b52bdb1602500dd947ce4d6361cf6805e9f3d691bd4f8b2214ece5d1b2b053"
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

        auto tracer = provider->GetTracer("foo_library", "1.0.0");
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
