class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/v0.5.0.tar.gz"
  sha256 "c20ee39bd8f519f874de3d1bc9dc65fb6430606d80badf34e070cc8a2225b62b"

  bottle do
    cellar :any
    sha256 "581deac0a13d95748ea4255e4636ad829c8317e4937e43adacaecb8e72d4fc4e" => :sierra
    sha256 "25d0db7a8e1555c826fc3ea929f9bf1cb1cddff695c0d1987bca27bad22fd8c0" => :el_capitan
    sha256 "876804db01aa0c42dd9c8f3d1a6fd272a02bf5d5f3468ab9485ae0f5dade9918" => :yosemite
    sha256 "21a99540dfcfe737bd59e12e34bf8f60ca7d08c535764f272750959df1d569d9" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    require "utils/json"

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

    test_ast = Utils::JSON.load pipe_output("#{libexec}/dump_json_ast", sample_query)
    assert_equal sample_ast, test_ast
  end
end
