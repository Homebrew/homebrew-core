class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/0.7.0.tar.gz"
  sha256 "63dae018f970dc2bdce431cbafbfa0bd3e6b10bba078bb997a3c1a40894aa35c"

  bottle do
    cellar :any
    sha256 "d41136363a3484d2d3f64585309154f1ba0b99c5ec830c50d13cdb6e3155af72" => :high_sierra
    sha256 "028d48186278fa12691294c46360fc1089b468ce88ea5164376be75b66ba8c43" => :sierra
    sha256 "7c8cfa351e83f68e4e5e7c98416a32a21af1e522ab6426a7123b59a40092ad66" => :el_capitan
    sha256 "f53b9bd6626d2d51eeadde6e39271d88be0f8a36e6416901792c5c6ec1384e2d" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    sample_query = <<-EOS.undent
      { user }
    EOS

    sample_ast = { "kind"=>"Document",
                   "loc"=>{ "start"=>{ "line"=>1, "column"=>1 },
                            "end"=>{ "line"=>1, "column"=>9 } },
                   "definitions"=>
        [{ "kind"=>"OperationDefinition",
           "loc"=>{ "start"=>{ "line"=>1, "column"=>1 },
                    "end"=>{ "line"=>1, "column"=>9 } },
           "operation"=>"query",
           "name"=>nil,
           "variableDefinitions"=>nil,
           "directives"=>nil,
           "selectionSet"=>
           { "kind"=>"SelectionSet",
             "loc"=>{ "start"=>{ "line"=>1, "column"=>1 },
                      "end"=>{ "line"=>1, "column"=>9 } },
             "selections"=>
             [{ "kind"=>"Field",
                "loc"=>{ "start"=>{ "line"=>1, "column"=>3 },
                         "end"=>{ "line"=>1, "column"=>7 } },
                "alias"=>nil,
                "name"=>
                { "kind"=>"Name",
                  "loc"=>{ "start"=>{ "line"=>1, "column"=>3 },
                           "end"=>{ "line"=>1, "column"=>7 } },
                  "value"=>"user" },
                "arguments"=>nil,
                "directives"=>nil,
                "selectionSet"=>nil }] } }] }

    test_ast = JSON.parse pipe_output("#{libexec}/dump_json_ast", sample_query)
    assert_equal sample_ast, test_ast
  end
end
