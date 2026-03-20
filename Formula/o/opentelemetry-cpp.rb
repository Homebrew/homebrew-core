class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "a0c944a9de981fe1874b31d1fe44b830fc30ee030efa27ee23fc73012a3a13e9"
  license "Apache-2.0"
  revision 2
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "3bc622572218f35b31d0694d7afbc481d9a58f4682cb22ff90b65a0cb7f84cfa"
    sha256               arm64_sequoia: "2e652c7a3b9106aa9ecdb07981ef0ac0a25a922a0a1fc63a0f07aeefb4340055"
    sha256               arm64_sonoma:  "299a13c39584b510c11bd9233e5dd946dc73e6c35fcdff7bb9a0ff4acd43322e"
    sha256 cellar: :any, sonoma:        "3daccbe6544f83c23e7613b5f0ef01ace87ec4fa6a98eee2020afa65a46dacc6"
    sha256               arm64_linux:   "404220054579f3c682d976672ef29119c757f6915f4854d827a01a348042d31c"
    sha256               x86_64_linux:  "83d731a65c3df00c5d0ffda2a634917173c0f90c77215135aa4e2de650ac9288"
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

  on_linux do
    depends_on "llvm" => :build if DevelopmentTools.gcc_version < 13
  end

  fails_with :gcc do
    version "12"
    cause "fails handling PROTOBUF_FUTURE_ADD_EARLY_WARN_UNUSED"
  end

  resource "openetelemetry-proto" do
    url "https://github.com/open-telemetry/opentelemetry-proto/archive/refs/tags/v1.9.0.tar.gz"
    sha256 "2d2220db196bdfd0aec872b75a5e614458f8396557fc718b28017e1a08db49e4"
  end

  def install
    # TODO: Remove after moving CI to Ubuntu 24.04. Cannot use newer GCC as it
    # will increase minimum GLIBCXX in bottle resulting in a runtime dependency.
    if OS.linux? && deps.map(&:name).any?("llvm")
      ENV.llvm_clang
      ENV.append "LDFLAGS", "-Wl,--as-needed"
    end

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
