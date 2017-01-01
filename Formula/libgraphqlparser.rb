class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/v0.6.0.tar.gz"
  sha256 "3d8f5878754203563d06a65175accb8ee9e4eb8b49cb51e6d5c6a1d9ff6aa5ad"

  bottle do
    cellar :any
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
                   "loc"=>{ "start"=>1, "end"=>9 },
                   "definitions"=>
        [{ "kind"=>"OperationDefinition",
           "loc"=>{ "start"=>1, "end"=>9 },
           "operation"=>"query",
           "name"=>nil,
           "variableDefinitions"=>nil,
           "directives"=>nil,
           "selectionSet"=>
           { "kind"=>"SelectionSet",
             "loc"=>{ "start"=>1, "end"=>9 },
             "selections"=>
             [{ "kind"=>"Field",
                "loc"=>{ "start"=>3, "end"=>7 },
                "alias"=>nil,
                "name"=>
                { "kind"=>"Name", "loc"=>{ "start"=>3, "end"=>7 }, "value"=>"user" },
                "arguments"=>nil,
                "directives"=>nil,
                "selectionSet"=>nil }] } }] }

    test_ast = JSON.parse pipe_output("#{libexec}/dump_json_ast", sample_query)
    assert_equal sample_ast, test_ast
  end
end
