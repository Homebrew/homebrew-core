class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "d09c2e8dd95bbc1d6ee493a89f32a4736879948d0eb59ad58c855022d1f55cc1"
  license "Apache-2.0"
  revision 2
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "1d6e4924c4595730929a414fbc5c70162de1e4551960ac7e264697d0d8294bf7"
    sha256               arm64_sequoia: "0f3b572df41115a20f9d479524daad59397c274cab06794c2dc238779eb9d3a5"
    sha256               arm64_sonoma:  "c8bd45c11516082476e101d4fa229beff6620fa3622025d13bdc51ac1af08187"
    sha256 cellar: :any, sonoma:        "f3182e6a3d71c5772e1fa4fd8765c0fa6a0dab026f213088f2bab2f2325a5c33"
    sha256               arm64_linux:   "8286c3612d422969666558f4cbcb47dfe0973308394d138e0b21e343a02fcb69"
    sha256               x86_64_linux:  "05d496201d7c644ee73b36f73abbede8b3a056923c9d32966a4ade3416c5752c"
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

    ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup" if OS.mac?
    system "cmake", "-S", ".", "-B", "build",
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
