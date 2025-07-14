class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.36.tgz"
  sha256 "34b687571794e56cad6b6c2cc8d0b7c80785b2133d6a83429ceb0c62a9e39fbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "215beabbff407657ebabfa06ab04e2a1cbff23c1626ae5cdee54707423c54ce5"
    sha256 cellar: :any,                 arm64_sonoma:  "215beabbff407657ebabfa06ab04e2a1cbff23c1626ae5cdee54707423c54ce5"
    sha256 cellar: :any,                 arm64_ventura: "215beabbff407657ebabfa06ab04e2a1cbff23c1626ae5cdee54707423c54ce5"
    sha256 cellar: :any,                 sonoma:        "6851b533fa5664f21ec4d7daa6718b455463fe95523f0f44cad54c1da08cb458"
    sha256 cellar: :any,                 ventura:       "6851b533fa5664f21ec4d7daa6718b455463fe95523f0f44cad54c1da08cb458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96fd5f0424390301c47feff6551b83726534a2606f2264bcbfd03343cb65864b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361d03d314836204a372c729f1d524731157975e2df67fca15892dd290031721"
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
