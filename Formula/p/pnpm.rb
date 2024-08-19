class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.7.1.tgz"
  sha256 "46f1bbc8f8020aa9869568c387198f1a813f21fb44c82f400e7d1dbde6c70b40"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00be32468e57c3f710f8ada545a63d7d346757b70cc77a1fc7dbf1cabed5b33e"
    sha256 cellar: :any,                 arm64_ventura:  "00be32468e57c3f710f8ada545a63d7d346757b70cc77a1fc7dbf1cabed5b33e"
    sha256 cellar: :any,                 arm64_monterey: "00be32468e57c3f710f8ada545a63d7d346757b70cc77a1fc7dbf1cabed5b33e"
    sha256 cellar: :any,                 sonoma:         "cbcd99325759373d2c261ed3dcd0c15e53a746d3832161233a79ba8b2878bbbd"
    sha256 cellar: :any,                 ventura:        "cbcd99325759373d2c261ed3dcd0c15e53a746d3832161233a79ba8b2878bbbd"
    sha256 cellar: :any,                 monterey:       "cbcd99325759373d2c261ed3dcd0c15e53a746d3832161233a79ba8b2878bbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "351155b92b05c98650572711b25a4619d17d481046c52dff84c06f58d9dcaffd"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
