class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "63effc2b0aaef32c9543bd95c8c227f1c80da8248392a6d97e8a2c3ffbcf7ea1"
  license "Apache-2.0"
  revision 2
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8d36b4b15d5424d5f91a21d42929b810c3f8aea1f09418aab4761b7c6e930272"
    sha256 cellar: :any, arm64_tahoe:       "16da1ac76628ec127ac6e1aec99784b650dd8f5114b954a857eb8fb8a5f7c921"
    sha256 cellar: :any, arm64_sequoia:     "948791187f7fc4ccdf33726a7cbd4d7ff8a214ec8b758e2a1142ac8d6357dcb3"
    sha256               arm64_linux:       "8c38b53e36b00ccb31c60c168b50dafcaad3cb87c09cc35cc11798997e8d4bf4"
    sha256               x86_64_linux:      "832d557a2ffb9f1c0d720084d506d58408a6c03e5b8e00195eaa148a3da81375"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf"

  uses_from_macos "curl"

  fails_with :gcc do
    version "12"
    cause "fails handling PROTOBUF_FUTURE_ADD_EARLY_WARN_UNUSED"
  end

  resource "opentelemetry-proto" do
    url "https://github.com/open-telemetry/opentelemetry-proto/archive/refs/tags/v1.10.0.tar.gz"
    sha256 "52c85df79badc45da7e6a8735e8090b05a961b0208756187e1492a40db2d1f5f"
  end

  def install
    (buildpath/"opentelemetry-proto").install resource("opentelemetry-proto")

    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DCMAKE_CXX_STANDARD=17", # Keep in sync with C++ standard in abseil.rb
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
      "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
      "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
      "-DOTELCPP_PROTO_PATH=#{buildpath}/opentelemetry-proto",
      "-DWITH_BENCHMARK=OFF",
      "-DWITH_ELASTICSEARCH=ON",
      "-DWITH_EXAMPLES=OFF",
      "-DWITH_OTLP_GRPC=ON",
      "-DWITH_OTLP_HTTP=ON",
      "-DWITH_PROMETHEUS=ON",
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP
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
