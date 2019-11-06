class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/0.7.0.tar.gz"
  sha256 "63dae018f970dc2bdce431cbafbfa0bd3e6b10bba078bb997a3c1a40894aa35c"

  bottle do
    cellar :any
    sha256 "d6eca9eeb1f1ab04d3931bc07bafc55010923381be523f20334d6340a3971e45" => :catalina
    sha256 "aac2103ad45e4cf7f45ba61e728a7be244a4f8982cd89082015a59ac9a011a7a" => :mojave
    sha256 "cffca81b24fb0914f2904592156f6ac7d6971807b81d72234cb0218fc7481cde" => :high_sierra
    sha256 "15805dc7067558d8af112caa85ebcb777122640d41cc1b7998e070ebdeafd62d" => :sierra
    sha256 "89d55800b60e750453ab196237c0935c89e069b26da608325a469c4ca4cddfb0" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    sample_query = <<~EOS
      { user }
    EOS

    sample_ast = { "kind"        => "Document",
                   "loc"         => { "start" => { "line"=>1, "column"=>1 },
                                      "end"   => { "line"=>1, "column"=>9 } },
                   "definitions" =>
                                    [{ "kind"                => "OperationDefinition",
                                       "loc"                 => { "start" => { "line"=>1, "column"=>1 },
                                                                  "end"   => { "line"=>1, "column"=>9 } },
                                       "operation"           => "query",
                                       "name"                => nil,
                                       "variableDefinitions" => nil,
                                       "directives"          => nil,
                                       "selectionSet"        =>
                                                                { "kind"       => "SelectionSet",
                                                                  "loc"        => { "start" => { "line"=>1, "column"=>1 },
                                                                                    "end"   => { "line"=>1, "column"=>9 } },
                                                                  "selections" =>
                                                                                  [{ "kind"         => "Field",
                                                                                     "loc"          => { "start" => { "line"=>1, "column"=>3 },
                                                                                                         "end"   => { "line"=>1, "column"=>7 } },
                                                                                     "alias"        => nil,
                                                                                     "name"         =>
                                                                                                       { "kind"  => "Name",
                                                                                                         "loc"   => { "start" => { "line"=>1, "column"=>3 },
                                                                                                                      "end"   => { "line"=>1, "column"=>7 } },
                                                                                                         "value" => "user" },
                                                                                     "arguments"    => nil,
                                                                                     "directives"   => nil,
                                                                                     "selectionSet" => nil }] } }] }

    test_ast = JSON.parse pipe_output("#{libexec}/dump_json_ast", sample_query)
    assert_equal sample_ast, test_ast
  end
end
