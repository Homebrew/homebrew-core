class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.5.tgz"
  sha256 "38686cda82cd1af88732cd1e00eb3f63796068047dadae6b38fa8c58df058562"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c346a0f26f2ef78bd19414c5ac316e49b9adba68c865a4badaa7c173adfa2d4"
    sha256 cellar: :any,                 arm64_sonoma:  "8c346a0f26f2ef78bd19414c5ac316e49b9adba68c865a4badaa7c173adfa2d4"
    sha256 cellar: :any,                 arm64_ventura: "8c346a0f26f2ef78bd19414c5ac316e49b9adba68c865a4badaa7c173adfa2d4"
    sha256 cellar: :any,                 sonoma:        "09818d0d138a0b65b490917fe19255172531996cdd1899b5859b09517355b25b"
    sha256 cellar: :any,                 ventura:       "09818d0d138a0b65b490917fe19255172531996cdd1899b5859b09517355b25b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e3a253e84b7f5ff7363a85fc1a11b7d08915a89529f28b9f3ed145d5a4b5bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a7e5504bd566834a0eef1b65d236feb4d76749d376aaa8c4e945d439a55fc5"
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
