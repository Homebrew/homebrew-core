require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.2.0.tgz"
  sha256 "151d36d3069dde1eb4aea9ae5501d969edaa99ee46b6cbb8fd591562833e8651"

  bottle do
    sha256 "e23a0ae41ec34b7f21229b6d1890e2d78cd3714ae3484804cde1c12679007ca7" => :mojave
    sha256 "081ae4f9aea6c689f8b41fca11798a05fedf9415f41bc3075a5a65d80eec1b67" => :high_sierra
    sha256 "06083f7fb5c29a5ec2ebc70d992ca91bcd88a7bdabd6755ea84b5358a1342223" => :sierra
  end

  depends_on "node"

  resource "babel-core" do
    url "https://registry.npmjs.org/@babel/core/-/core-7.2.0.tgz"
    sha256 "7f60c1a95f03c86b0e9329989045f460c3fb86ce6d4f545327b6091f1ca37eae"
  end

  def install
    (buildpath/"node_modules/@babel/core").install resource("babel-core")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = resource("babel-core").version
    pkg_json["bundledDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"

    assert_equal version, resource("babel-core").version
  end
end
