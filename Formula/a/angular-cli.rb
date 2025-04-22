class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.8.tgz"
  sha256 "0e658b2619b2fb6220530f39e4c678cf8354b4806cedf101a7371646541e5187"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541cdfd7f437942c9f14a41474d3a22fe5b92cd79c7afabd959ac2d6c1fc47a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541cdfd7f437942c9f14a41474d3a22fe5b92cd79c7afabd959ac2d6c1fc47a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "541cdfd7f437942c9f14a41474d3a22fe5b92cd79c7afabd959ac2d6c1fc47a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b248439f1a11bc3541634ec28fe6dcd5a3d1a1efbfa5b4ffdb2f500fd36b83e0"
    sha256 cellar: :any_skip_relocation, ventura:       "b248439f1a11bc3541634ec28fe6dcd5a3d1a1efbfa5b4ffdb2f500fd36b83e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "541cdfd7f437942c9f14a41474d3a22fe5b92cd79c7afabd959ac2d6c1fc47a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "541cdfd7f437942c9f14a41474d3a22fe5b92cd79c7afabd959ac2d6c1fc47a3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
