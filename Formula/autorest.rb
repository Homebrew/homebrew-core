require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-2.0.4283.tgz"
  sha256 "a655719fa6dd20b11db4a3d9c5853e9ed0454429bd6371f0bc6a5a9014b1bb8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "71f76d0fdc89273b98b90fc4cdc2282980a380396ca3f5d483917a3f355320bc" => :mojave
    sha256 "63768f566900eee86561a21b495b3627183fb1c05db98220561d58dad0d7a5d2" => :high_sierra
    sha256 "da1dc0e3a25b005db13ffbb95b145c060162648ad700998e4814a7969e17cbb1" => :sierra
    sha256 "da1dc0e3a25b005db13ffbb95b145c060162648ad700998e4814a7969e17cbb1" => :el_capitan
    sha256 "da1dc0e3a25b005db13ffbb95b145c060162648ad700998e4814a7969e17cbb1" => :yosemite
  end

  depends_on "mono"
  depends_on "node"

  resource "swagger" do
    url "https://raw.githubusercontent.com/Azure/autorest/764d308b3b75ba83cb716708f5cef98e63dde1f7/Samples/petstore/petstore.json"
    sha256 "8de4043eff83c71d49f80726154ca3935548bd974d915a6a9b6aa86da8b1c87c"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("swagger").stage do
      system bin/"autorest", "--input-file=petstore.json"
    end
  end
end
