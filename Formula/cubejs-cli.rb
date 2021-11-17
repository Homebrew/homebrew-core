require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.57.tgz"
  sha256 "c49c235c015d2e292f26c2fb20582b872d2d1924291a0d25b13728d6776f4c77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0164d4064b45e27390ae734e20234ffd511992a9e4853a57d36e7558bb850871"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0164d4064b45e27390ae734e20234ffd511992a9e4853a57d36e7558bb850871"
    sha256 cellar: :any_skip_relocation, monterey:       "a1039fae0603d0a457246bc31c545afcdf3a6b390b227eadc994cae3602f04bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1039fae0603d0a457246bc31c545afcdf3a6b390b227eadc994cae3602f04bd"
    sha256 cellar: :any_skip_relocation, catalina:       "a1039fae0603d0a457246bc31c545afcdf3a6b390b227eadc994cae3602f04bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0164d4064b45e27390ae734e20234ffd511992a9e4853a57d36e7558bb850871"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
