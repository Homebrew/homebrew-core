require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.6.3.tgz"
  sha256 "d6deb4c56e1e6e2afd802a73f1f3e5654dc81f05528b85b085981ed3e7dd4236"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64a4b7d5f30ccc95df61c4681c900f10ff2a07e70ee223981e9a8f0fc9d10dde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a4b7d5f30ccc95df61c4681c900f10ff2a07e70ee223981e9a8f0fc9d10dde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64a4b7d5f30ccc95df61c4681c900f10ff2a07e70ee223981e9a8f0fc9d10dde"
    sha256 cellar: :any_skip_relocation, ventura:        "48ea1a0709991740b7bcf1fab2407d1533400e37eed30e50c00e2821b00b958a"
    sha256 cellar: :any_skip_relocation, monterey:       "48ea1a0709991740b7bcf1fab2407d1533400e37eed30e50c00e2821b00b958a"
    sha256 cellar: :any_skip_relocation, big_sur:        "48ea1a0709991740b7bcf1fab2407d1533400e37eed30e50c00e2821b00b958a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a4b7d5f30ccc95df61c4681c900f10ff2a07e70ee223981e9a8f0fc9d10dde"
  end

  depends_on "node@18"

  resource "homebrew-petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"autorest").write_env_script "#{libexec}/bin/autorest", { PATH: "#{node.opt_bin}:$PATH" }
  end

  test do
    resource("homebrew-petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--typescript",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
