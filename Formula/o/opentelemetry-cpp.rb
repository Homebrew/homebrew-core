class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "7735cc56507149686e6019e06f588317099d4522480be5f38a2a09ec69af1706"
  license "Apache-2.0"
  revision 3
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "73185e6636548ed8b6c93b1ac41a1ea38d61d080182d588f081825a40d3f2b67"
    sha256 cellar: :any,                 arm64_ventura:  "62ae9fe753ab3df2204f8f8f0c52dd914a71d3fc471bb81b55b9c3b0819def89"
    sha256 cellar: :any,                 arm64_monterey: "bbea2be70d11bd71668116c7a2d39d8b4bbc3925fecc6b958f3cad44e4c966ba"
    sha256 cellar: :any,                 sonoma:         "9ddbeff86bb876f4682c4ec72ebf2bd0b1929b17112d02797ea15e03e08f15a6"
    sha256 cellar: :any,                 ventura:        "518fac78d4a8269757e36d79b46b0ce65f84e25af24039541ed08f690d38554a"
    sha256 cellar: :any,                 monterey:       "8d40fd67211e18eba09a53f1f5d3f1dc897ad2a11b288bc1c5dc91ec831ca181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7a1daa41af566068965bffa976224e1bcb8f0eb70d259e73b2a20411ab2a40"
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
