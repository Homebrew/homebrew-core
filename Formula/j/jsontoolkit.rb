class Jsontoolkit < Formula
  desc "Swiss-army knife library for expressive JSON programming in modern C++"
  homepage "https://jsontoolkit.sourcemeta.com/"
  url "https://github.com/sourcemeta/jsontoolkit/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "00f82f02166beabec80522e2bbc7b839ee9b7ccb631411c42e6fab65186e80ba"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4bdb1c92bc5d58c6ecff06644af109f714e087e7005bfd86db5cb623610d0be3"
    sha256 cellar: :any,                 arm64_sonoma:   "db44ed711e76947fdcb106dbc0501306e04cb649e66c523ad68b79513b5b5128"
    sha256 cellar: :any,                 arm64_ventura:  "cdfad362acd1612e6bfca265a162775f56839029cba214b98caa4dd68d65ca7f"
    sha256 cellar: :any,                 arm64_monterey: "ffe5e64bf78410c1467804c862b83156c47d455f53bbd941f256324f13ccb627"
    sha256 cellar: :any,                 sonoma:         "1eb414104958725535408765ecc618e76bdaacaf07a491e1361799200dde54a4"
    sha256 cellar: :any,                 ventura:        "82f13b513c2f80a41b9362e5dd116f413cdf5d1d4d603664c36884d7149855ed"
    sha256 cellar: :any,                 monterey:       "ab1e654b6af6f056ed2bfaa18ee9f220be238166e965f343ef23ba0ee43f06ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7201211ab61aa4766b12221174fd6fa7215e99571a2f898395d1fedbe19432c7"
  end

  # Original source is no longer available after repo change
  deprecate! date: "2025-04-17", because: :does_not_build

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCMAKE_COMPILE_WARNING_AS_ERROR=OFF
      -DJSONTOOLKIT_CONTRIB=OFF
      -DJSONTOOLKIT_TESTS=OFF
      -DJSONTOOLKIT_DOCS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <sourcemeta/jsontoolkit/json.h>
      #include <sourcemeta/jsontoolkit/jsonl.h>
      #include <sourcemeta/jsontoolkit/jsonpointer.h>
      #include <sourcemeta/jsontoolkit/jsonschema.h>

      #include <cassert>
      #include <iostream>
      #include <sstream>

      int main() {
        // JSON
        const sourcemeta::jsontoolkit::JSON json_doc =
            sourcemeta::jsontoolkit::parse(R"([ { "foo": 1 }, { "bar": 2 } ])");
        assert(json_doc.is_array());

        // JSON Pointer
        const sourcemeta::jsontoolkit::Pointer pointer{1, "bar"};
        const sourcemeta::jsontoolkit::JSON &value{
            sourcemeta::jsontoolkit::get(json_doc, pointer)};
        assert(value.is_integer());
        assert(value.to_integer() == 2);

        // JSONL
        std::istringstream jsonl_input(
            R"JSON({ "foo": 1 }
            { "bar": 2 }
            { "baz": 3 })JSON");
        for (const auto &document : sourcemeta::jsontoolkit::JSONL{jsonl_input}) {
          assert(document.is_object());
        }

        // JSON Schema
        const sourcemeta::jsontoolkit::JSON schema{
            sourcemeta::jsontoolkit::parse(R"JSON({
          "$schema": "http://json-schema.org/draft-04/schema#",
          "type": "string"
        })JSON")};

        const auto compiled_schema{sourcemeta::jsontoolkit::compile(
            schema, sourcemeta::jsontoolkit::default_schema_walker,
            sourcemeta::jsontoolkit::official_resolver,
            sourcemeta::jsontoolkit::default_schema_compiler)};

        const sourcemeta::jsontoolkit::JSON instance{"foo bar"};
        const auto result{
            sourcemeta::jsontoolkit::evaluate(compiled_schema, instance)};
        assert(result);

        std::cout << "JSON Toolkit works!" << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}",
       "-L#{lib}",
       "-lsourcemeta_jsontoolkit_json",
       "-lsourcemeta_jsontoolkit_jsonschema",
       "-lsourcemeta_jsontoolkit_jsonl",
       "-lsourcemeta_jsontoolkit_jsonpointer",
       "-lsourcemeta_jsontoolkit_uri",
       "-o", "test"
    system "./test"
  end
end
