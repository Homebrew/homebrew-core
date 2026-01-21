class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "7b8e966affca1daf1906272f4d983631cad85fb6ea60fb6f55dcd1811a730604"
  license "Apache-2.0"
  revision 3
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "880167113694f99256485131f9a8df6648fd5a0dc24aa9f0b8785f24107c2e9f"
    sha256               arm64_sequoia: "8fc6c22997a06cc8fc5d73ee881b114c9dda77d0d8e1d875241363fedc27a8db"
    sha256               arm64_sonoma:  "0e618285078e2a9364a61094adbf2ba437215439a8c2d6288a9d7840138b1ca3"
    sha256 cellar: :any, sonoma:        "68899d29e9df085cf200eb6105f5276b685c3bccb7d4e661dec9735a4cbb0a68"
    sha256               arm64_linux:   "cd27e654f2d665c19d567578aefe131dbf436a64b9139b4e60326a1dffeaad48"
    sha256               x86_64_linux:  "18466616d3f133dfea7c82a49b583d2493360b9b0230f2896c6532b114d6c94c"
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
    url "https://github.com/open-telemetry/opentelemetry-proto/archive/refs/tags/v1.9.0.tar.gz"
    sha256 "2d2220db196bdfd0aec872b75a5e614458f8396557fc718b28017e1a08db49e4"
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
