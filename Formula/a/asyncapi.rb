require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.12.2.tgz"
  sha256 "4da499ec9dcc452e8874832b3f7da2d33a3f5741ceb8923e0e0095f3facd2efe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "883dd972c163cfd674d153f665ad7efed1f2a84ca85ebb3ef8dc849979dad067"
    sha256 cellar: :any,                 arm64_ventura:  "68fbf7d92e39b79ac9020219f0622ea7074c36d065b51e391a87872ff6be3347"
    sha256 cellar: :any,                 arm64_monterey: "4c3630f90120a8ab7f41b8f9122533eec932e1a23cfebda330230d6b1c2418f2"
    sha256 cellar: :any,                 sonoma:         "0133e37c35a0fc8f1e1b943a288a6ceadc1c86169f290661d1d344284514bddf"
    sha256 cellar: :any,                 ventura:        "b9632608ca4e691e0c8977366459a4c61541177d614fc190aae4366fbf0f24db"
    sha256 cellar: :any,                 monterey:       "f0686577222e93551410e53fa79a05c0d365cfc95817f09816f3762fd08bb8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b6e482efcf58e90dfe75411594147c8d2a842d8bc2ccced27c57ad30f32c58"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
