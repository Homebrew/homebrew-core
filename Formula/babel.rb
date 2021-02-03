require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.12.13.tgz"
  sha256 "a128a4fa43e5b9032c709caaaf9b93a166a9bb7f7e78dbaff689a76e48900cdb"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ca4905e175c2575f5c097120b0b375de6b7edd4dcbd051fdb979a1fd4a7b1da"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c6c97edbee426fd6cec35a5c127877bc1f5ae69238dbe98708b22338b7758d4"
    sha256 cellar: :any_skip_relocation, catalina:      "ef060957fcf86295ac997da9ff49e857535e3193186ff7f21d544465a53415d3"
    sha256 cellar: :any_skip_relocation, mojave:        "6d693bf124636a8968b6f5acd35044f887f863e796f555ab99c3c4b2cdb157c6"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.12.13.tgz"
    sha256 "4c1b4b189e4d2f68d891a33aeac7f74531a004685dde6d102e4aad357553dc3e"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
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
  end
end
