class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "09c208a21fb1159d114a3ea15dc1bcc5dee28eb39907ba72a6012d2c7b7564a0"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d523af87d04b0d5fe6a5aaa5d3bfffa8c4565e92b96d396ccac9759dfef91ec"
    sha256 cellar: :any,                 arm64_ventura:  "9a237e7c99689f1ad0a97e9919ed84a1fc39054c74ad6878b9b7f2847056c740"
    sha256 cellar: :any,                 arm64_monterey: "6b4c3b8bcd942843db0e04a0be7cdf0cd69304d63b80dd832818f18d863fd3a1"
    sha256 cellar: :any,                 sonoma:         "b10546ddf975f77c8e74d95f9dc15ca336e4757e8f4fc9241d7cb82a05e62812"
    sha256 cellar: :any,                 ventura:        "272fa5526555ac3e6b721bc0d2da12e6deaec5874b5d606cf4fb965d509be9a6"
    sha256 cellar: :any,                 monterey:       "e0e430615532c53d310bae8b6f8f074fe0b6e3a079fe34c3f4bd0e96031f4f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a5f5842d49317e09fd9a687eca6556fb8ce2beea36b3c98e290fb024f7f6515"
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
