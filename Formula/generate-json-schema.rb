require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.1.1.tgz"
  sha256 "8f30beb978627b39831eaabf27df9df6e075b0bcc27e6543fab7582f3f30857d"

  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0915c902a8de34bfe2298d4f91040eea18762c0e3e68747ce6e32a07e135810c" => :sierra
    sha256 "d573136e4025aa6ecdad3ca73bfc53307ef6ab212bd8307387a7ff9763db14ed" => :el_capitan
    sha256 "ac72c27b5ae36a0c40ba48b21d590519175395bd903ca7a3c46e4af840daa449" => :yosemite
    sha256 "8fc1b18f001ea586ce7f3e5d5c021ad76be4cb8010688a783a1c80b22e3e3167" => :mavericks
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

    input = <<-EOS.undent
      {
          "id": 2,
          "name": "An ice sculpture",
          "price": 12.50,
          "tags": ["cold", "ice"],
          "dimensions": {
              "length": 7.0,
              "width": 12.0,
              "height": 9.5
          },
          "warehouseLocation": {
              "latitude": -78.75,
              "longitude": 20.4
          }
      }
    EOS

    output = <<-EOS.undent.chomp
      Welcome to Generate Schema 2.1.1

        Mode: json

      * Example Usage:
        > {a:'b'}
        { a: { type: 'string' } }

      To quit type: exit

      > {
        "$schema": "http://json-schema.org/draft-04/schema#",
        "type": "object",
        "properties": {
          "id": {
            "type": "number"
          },
          "name": {
            "type": "string"
          },
          "price": {
            "type": "number"
          },
          "tags": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "dimensions": {
            "type": "object",
            "properties": {
              "length": {
                "type": "number"
              },
              "width": {
                "type": "number"
              },
              "height": {
                "type": "number"
              }
            }
          },
          "warehouseLocation": {
            "type": "object",
            "properties": {
              "latitude": {
                "type": "number"
              },
              "longitude": {
                "type": "number"
              }
            }
          }
        }
      }
      >
    EOS

    # As of v2.1.1, there is a bug when passing in a filename as an argument
    # The following commented out test will fail until this bug is fixed.
    # ("#{testpath}/test.json").write(input)
    # system "#{bin}/generate-schema", "#{testpath}/test.json"

    # Until it is fixed, STDIN can be used as a workaround
    Open3.popen3("#{bin}/generate-schema") do |stdin, stdout, _|
      stdin.write(input)
      stdin.close
      # Program leaks spaces at the end of lines. This line cleans them up
      # so they don't cause the assert below to erroneously fail.
      result = stdout.map(&:rstrip).join("\n")
      assert_equal output, result
    end
  end
end
