class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.64.tgz"
  sha256 "b5f0d968b3770bee22b642ae3d407b1ad2bd876d2be589b3f48d1a536957666b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d2a42af10cfb3e7a3b0d167529a7ea79d1c22bb853dea80338b89aa30804d1d"
    sha256 cellar: :any,                 arm64_sonoma:  "9d2a42af10cfb3e7a3b0d167529a7ea79d1c22bb853dea80338b89aa30804d1d"
    sha256 cellar: :any,                 arm64_ventura: "9d2a42af10cfb3e7a3b0d167529a7ea79d1c22bb853dea80338b89aa30804d1d"
    sha256 cellar: :any,                 sonoma:        "61051a22c596f418077b732bc750b92ce5a448215870d98881e14620e9f4ede0"
    sha256 cellar: :any,                 ventura:       "61051a22c596f418077b732bc750b92ce5a448215870d98881e14620e9f4ede0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48c8e7dccae505dbeefef9654628d63fd9a9ad2ad7d446c9e5b6222829588de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1c623a9974730ee46aa7105be3c2ed681a7ea18e85c0b9475f72906fb783dd"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
