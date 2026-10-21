class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "b718fe71acf9f87a5e8c464b8b1ff611a48984d3b77e6a838db14e6014ef9bed"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a3b6de3f1297dc0ab77585cab6e64417f026c3dbd87ad447530342626e66a75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3f66ef2a1a3b980dbbea32bb425ec64059e0a3e2b6c50cb26827570ab9557ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6b566288257f9231ffba2f053b2afbce12a21280cf93b98932528a677da6937"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "279928d50cf48947f49f871cf41c11fe6e7fc9b1fa2199f25b8d678ce8335238"
    sha256 cellar: :any,                 x86_64_linux:      "ce6600352e1cfe63e5b51ce739b8e692b7e8c419b960604d5e526f96c8627d17"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/jet"
  end

  test do
    cmd = "#{bin}/jet -source=mysql -host=localhost -port=3306 -user=jet -password=jet -dbname=jetdb -path=./gen 2>&1"
    assert_match "connection refused", shell_output(cmd, 2)
  end
end
