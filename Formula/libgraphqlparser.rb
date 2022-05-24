class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/0.7.0.tar.gz"
  sha256 "63dae018f970dc2bdce431cbafbfa0bd3e6b10bba078bb997a3c1a40894aa35c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "b1c9fe6543d03c805f024d800e0720dc10bb9c135e84dc47a4ba35aa85c563cf"
    sha256 cellar: :any, arm64_big_sur:  "bd069fd2209297f1138771054ba16ac79f3710334e9d819c9ef556cd9461437d"
    sha256 cellar: :any, monterey:       "a06666904ca4ae8118e3f9bc4b7bb83558fb9e9755bc4239ca757611c6f5fcbf"
    sha256 cellar: :any, big_sur:        "7929bde96a18ea4200a11d392d981044a8580a05676702e866e40dcb21f39c02"
    sha256 cellar: :any, catalina:       "e4cea535715f0ed46ff1713df73dbc43d2845f4e0152f0137d4ad18def845050"
    sha256 cellar: :any, mojave:         "f2d46a3bfb5fd3aef9f8b47a5d1c50d204f6dbd74d1a387ca664e36022b7ddc4"
    sha256 cellar: :any, high_sierra:    "64779ec3108d9eef789d279abfafa90437c6a76b2ed3973d45979cd1051dc170"
  end

  deprecate! date: "2020-04-20", because: "requires Python 2 to build"

  depends_on "cmake" => :build
  depends_on :macos # Due to Python 2

  def install
    system "cmake", ".", "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                         *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    sample_query = <<~EOS
      { user }
    EOS

    sample_ast = JSON.parse(<<~EOS)
      {
        "kind": "Document",
        "loc": {
          "start": {
            "line": 1,
            "column": 1
          },
          "end": {
            "line": 1,
            "column": 9
          }
        },
        "definitions": [
          {
            "kind": "OperationDefinition",
            "loc": {
              "start": {
                "line": 1,
                "column": 1
              },
              "end": {
                "line": 1,
                "column": 9
              }
            },
            "operation": "query",
            "name": null,
            "variableDefinitions": null,
            "directives": null,
            "selectionSet": {
              "kind": "SelectionSet",
              "loc": {
                "start": {
                  "line": 1,
                  "column": 1
                },
                "end": {
                  "line": 1,
                  "column": 9
                }
              },
              "selections": [
                {
                  "kind": "Field",
                  "loc": {
                    "start": {
                      "line": 1,
                      "column": 3
                    },
                    "end": {
                      "line": 1,
                      "column": 7
                    }
                  },
                  "alias": null,
                  "name": {
                    "kind": "Name",
                    "loc": {
                      "start": {
                        "line": 1,
                        "column": 3
                      },
                      "end": {
                        "line": 1,
                        "column": 7
                      }
                    },
                    "value": "user"
                  },
                  "arguments": null,
                  "directives": null,
                  "selectionSet": null
                }
              ]
            }
          }
        ]
      }
    EOS

    test_ast = JSON.parse pipe_output("#{libexec}/dump_json_ast", sample_query)
    assert_equal sample_ast, test_ast
  end
end
