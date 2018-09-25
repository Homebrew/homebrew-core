class OpentracingCpp < Formula
  desc "OpenTracing API for C++"
  homepage "http://opentracing.io"
  url "https://github.com/opentracing/opentracing-cpp/archive/v1.5.0.tar.gz"
  sha256 "4455ca507936bc4b658ded10a90d8ebbbd61c58f06207be565a4ffdc885687b5"
  depends_on "cmake" => :build

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    # This is from example/tutorial/tutorial-example.cpp, minus empty lines
    (testpath/"tutorial-example.cpp").write <<~'EOS'
      // Demonstrates basic usage of the OpenTracing API. Uses OpenTracing's
      // mocktracer to capture all the recorded spans as JSON.
      #include <opentracing/mocktracer/json_recorder.h>
      #include <opentracing/mocktracer/tracer.h>
      #include <cassert>
      #include <iostream>
      #include <sstream>
      #include <unordered_map>
      #include "text_map_carrier.h"
      using namespace opentracing;
      using namespace opentracing::mocktracer;
      int main() {
        MockTracerOptions options;
        std::unique_ptr<std::ostringstream> output{new std::ostringstream{}};
        std::ostringstream& oss = *output;
        options.recorder = std::unique_ptr<mocktracer::Recorder>{
            new JsonRecorder{std::move(output)}};
        std::shared_ptr<opentracing::Tracer> tracer{
            new MockTracer{std::move(options)}};
        auto parent_span = tracer->StartSpan("parent");
        assert(parent_span);
        // Create a child span.
        {
          auto child_span =
              tracer->StartSpan("childA", {ChildOf(&parent_span->context())});
          assert(child_span);
          // Set a simple tag.
          child_span->SetTag("simple tag", 123);
          // Set a complex tag.
          child_span->SetTag("complex tag",
                             Values{123, Dictionary{{"abc", 123}, {"xyz", 4.0}}});
          // Log simple values.
          child_span->Log({{"event", "simple log"}, {"abc", 123}});
          // Log complex values.
          child_span->Log({{"event", "complex log"},
                           {"data", Dictionary{{"a", 1}, {"b", Values{1, 2}}}}});
          child_span->Finish();
        }
        // Create a follows from span.
        {
          auto child_span =
              tracer->StartSpan("childB", {FollowsFrom(&parent_span->context())});
          // child_span's destructor will finish the span if not done so explicitly.
        }
        // Use custom timestamps.
        {
          auto t1 = SystemClock::now();
          auto t2 = SteadyClock::now();
          auto span = tracer->StartSpan(
              "useCustomTimestamps",
              {ChildOf(&parent_span->context()), StartTimestamp(t1)});
          assert(span);
          span->Finish({FinishTimestamp(t2)});
        }
        // Extract and Inject a span context.
        {
          std::unordered_map<std::string, std::string> text_map;
          TextMapCarrier carrier(text_map);
          auto err = tracer->Inject(parent_span->context(), carrier);
          assert(err);
          auto span_context_maybe = tracer->Extract(carrier);
          assert(span_context_maybe);
          auto span = tracer->StartSpan("propagationSpan",
                                        {ChildOf(span_context_maybe->get())});
        }
        // You get an error when trying to extract a corrupt span.
        {
          std::unordered_map<std::string, std::string> text_map = {
              {"x-ot-span-context", "123"}};
          TextMapCarrier carrier(text_map);
          auto err = tracer->Extract(carrier);
          assert(!err);
          assert(err.error() == span_context_corrupted_error);
          // How to get a readable message from the error.
          std::cout << "Example error message: \"" << err.error().message() << "\"\n";
        }
        parent_span->Finish();
        tracer->Close();
        std::cout << "\nRecorded spans as JSON:\n\n";
        std::cout << oss.str() << "\n";
        return 0;
      }
    EOS
    # This is from example/tutorial/text_map_carrier.h, minus empty lines
    (testpath/"text_map_carrier.h").write <<~'EOS'
      #ifndef LIGHTSTEP_TEXT_MAP_CARRIER
      #define LIGHTSTEP_TEXT_MAP_CARRIER
      #include <opentracing/propagation.h>
      #include <string>
      #include <unordered_map>
      using opentracing::TextMapReader;
      using opentracing::TextMapWriter;
      using opentracing::expected;
      using opentracing::string_view;
      class TextMapCarrier : public TextMapReader, public TextMapWriter {
       public:
        TextMapCarrier(std::unordered_map<std::string, std::string>& text_map)
            : text_map_(text_map) {}
        expected<void> Set(string_view key, string_view value) const override {
          text_map_[key] = value;
          return {};
        }
        expected<void> ForeachKey(
            std::function<expected<void>(string_view key, string_view value)> f)
            const override {
          for (const auto& key_value : text_map_) {
            auto result = f(key_value.first, key_value.second);
            if (!result) return result;
          }
          return {};
        }
       private:
        std::unordered_map<std::string, std::string>& text_map_;
      };
      #endif  // LIGHTSTEP_TEXT_MAP_CARRIER
    EOS
    (testpath/"CMakeLists.txt").write <<~'EOS'
      cmake_minimum_required(VERSION 3.1)
      project(tracingtest)
      set(CMAKE_CXX_STANDARD 11)
      find_package(OpenTracing REQUIRED)
      add_executable(tutorial-example tutorial-example.cpp)
      target_link_libraries(tutorial-example opentracing)
      target_link_libraries(tutorial-example opentracing_mocktracer)
    EOS
    system "cmake", "."
    system "make", "tutorial-example"
    system "./tutorial-example"
  end
end
