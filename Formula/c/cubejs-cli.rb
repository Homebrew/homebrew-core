class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.14.tgz"
  sha256 "3e943954abb1deb93fdfbd5d670718701a2ab3468d2ab8ce4310846d3d3e2e4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "817e076fc50c8a6eda4672fed5de54908497890acf0d16a1252576bbba0c9de8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26147bb21febd4a2fb5783bbedf08e1143a66ed95697f0431f6a80ceb8b9fb97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26147bb21febd4a2fb5783bbedf08e1143a66ed95697f0431f6a80ceb8b9fb97"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fb862e6cc0197e290f30b81a2b26cb4e371923969d516afd6c70708db49038c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbc205e96706a04405e35db95bd0a8c51d2dda7da42ebcb465b437446f27f84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbc205e96706a04405e35db95bd0a8c51d2dda7da42ebcb465b437446f27f84a"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
