class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.0.0.tgz"
  sha256 "78dec2aabbf2f3707737b8f49fa3d89a1916825e4387aeac8316d08806e9695c"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d6a38c5fb0d636fb8790c5eec2dc584498c8f01ec19d49e60e69b91c814b125" => :catalina
    sha256 "32fff357a7a8a6f7e7eacd682f8c99ec2beb2b3cabe491b9de569d26e3d4a4a1" => :mojave
    sha256 "71d169da0853da6a56f6cbd56ece0cf3ab6013bba1c31f5e202fa980b6b1d849" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
