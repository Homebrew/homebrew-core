require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.17.tgz"
  sha256 "f3422c3375f6525aeb6192e273d200d7759313394e3b84ccddc9fbed6021b875"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a1604d26b9f5e312f0a738617517358e33450fe254b8d29cb6df8387caf0c54"
    sha256 cellar: :any,                 arm64_ventura:  "3a1604d26b9f5e312f0a738617517358e33450fe254b8d29cb6df8387caf0c54"
    sha256 cellar: :any,                 arm64_monterey: "3a1604d26b9f5e312f0a738617517358e33450fe254b8d29cb6df8387caf0c54"
    sha256 cellar: :any,                 sonoma:         "eaf9bd91c946659018a2c27b7aad400a0de941d93be0991e09636d4e04ef74fc"
    sha256 cellar: :any,                 ventura:        "eaf9bd91c946659018a2c27b7aad400a0de941d93be0991e09636d4e04ef74fc"
    sha256 cellar: :any,                 monterey:       "eaf9bd91c946659018a2c27b7aad400a0de941d93be0991e09636d4e04ef74fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a382c3148e3cf1701720a700016d7d164fbfcb854d663c89cf4129226ec83ca"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
