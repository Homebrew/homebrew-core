require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.63.tgz"
  sha256 "0328f452a21e209ffab6409a7468d6095cb0427b3f38069d5d10893a35908077"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "215923d67e2dadf1f816002ceb04ebae3dfcfc9195fb34e2899f84be908573e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215923d67e2dadf1f816002ceb04ebae3dfcfc9195fb34e2899f84be908573e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "215923d67e2dadf1f816002ceb04ebae3dfcfc9195fb34e2899f84be908573e2"
    sha256 cellar: :any_skip_relocation, ventura:        "3b0fd7f35a6e24f25bcc3374590d9882e5857e8e96a25eadfb060e95c2626dff"
    sha256 cellar: :any_skip_relocation, monterey:       "3b0fd7f35a6e24f25bcc3374590d9882e5857e8e96a25eadfb060e95c2626dff"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b0fd7f35a6e24f25bcc3374590d9882e5857e8e96a25eadfb060e95c2626dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "215923d67e2dadf1f816002ceb04ebae3dfcfc9195fb34e2899f84be908573e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
