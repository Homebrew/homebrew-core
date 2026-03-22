class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.25.tgz"
  sha256 "6894b433819ebdbceb219b68f7dcf9d8bb8453cbfcc82383dabb18fffa8254e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a76544f6fe1c89b2977d0147252b8d060cc075335a8693d5b285a75215d89dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a8d0f3effe0ae0760b10d0bed3dfad9b591c5a6a9aecf5cea2f9bd5c2f47275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a8d0f3effe0ae0760b10d0bed3dfad9b591c5a6a9aecf5cea2f9bd5c2f47275"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc76552d8640f52f6e74999128cb49e023803aafe77880730dfe083d2b9a7c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4df87fc3e9f50ad9cab30af7e46b5b420c0c599025aca67b59d1546af614d287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df87fc3e9f50ad9cab30af7e46b5b420c0c599025aca67b59d1546af614d287"
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
