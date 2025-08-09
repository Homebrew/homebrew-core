class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "3428f433f4b435ed1fad64cbdbe75b7288c06f6297786a7036d65d5b9a1d215b"
  license "Apache-2.0"
  revision 3
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "61769b16d2b143e75647e72c9b431ccd8a007d2741bf0f5a84dcc2932d935596"
    sha256                               arm64_sonoma:  "1e91958195380333ae606e4a48c9b46ef0b70c6b549c6e96328c92d39634e2fd"
    sha256                               arm64_ventura: "bacab5c85b9034570ea279d56aacaf6494b4db898a5d3e1c2411cb46263b727e"
    sha256 cellar: :any,                 sonoma:        "0d08ee396cc742cd3ad81bd32b2b687416740a71b0c372a2b776c26e7b22dc35"
    sha256 cellar: :any,                 ventura:       "1fff50d155bd09dcf5485b9654a8540d6340c2e493b891cffdc5d2d8c0c13b63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "778bea0fc70b7a85596fe9368f8b574ccf605ae29045878eca627a3dd762aca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b1491820b7036b3262c28ef61038005dad711d42266d174bada9198f130593"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf"

  uses_from_macos "curl"

  on_macos do
    depends_on "c-ares"
    depends_on "openssl@3"
    depends_on "re2"
  end

  resource "openetelemetry-proto" do
    url "https://github.com/open-telemetry/opentelemetry-proto/archive/refs/tags/v1.7.0.tar.gz"
    sha256 "11330d850f5e24d34c4246bc8cb21fcd311e7565d219195713455a576bb11bed"
  end

  def install
    (buildpath/"opentelemetry-proto").install resource("openetelemetry-proto")

    ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup" if OS.mac?
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_CXX_STANDARD=17", # Keep in sync with C++ standard in abseil.rb
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
                    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
                    "-DOTELCPP_PROTO_PATH=#{buildpath}/opentelemetry-proto",
                    "-DWITH_ELASTICSEARCH=ON",
                    "-DWITH_EXAMPLES=OFF",
                    "-DWITH_OTLP_GRPC=ON",
                    "-DWITH_OTLP_HTTP=ON",
                    "-DWITH_ABSEIL=ON",
                    "-DWITH_PROMETHEUS=ON",
                    *std_cmake_args
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
