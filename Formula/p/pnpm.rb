class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.10.0.tgz"
  sha256 "620b6605ea4f62fc56a6d0a98733f479071d0321e03e486b522c7e9a74617431"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8042453c7ad4027cb8d2b164dca68b5a2da200117b036dd7727e81650f8ea3f0"
    sha256 cellar: :any,                 arm64_sequoia: "ac6bc7d6f1628e5bfb9a8187bf74bb611cf79d15e72cdee3af2776af1a1775c8"
    sha256 cellar: :any,                 arm64_sonoma:  "ac6bc7d6f1628e5bfb9a8187bf74bb611cf79d15e72cdee3af2776af1a1775c8"
    sha256 cellar: :any,                 sonoma:        "084cfd774d60db256de911872d44113279c903dc5c7778e7878bb3fe033825b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4892e83083debfd8eeb929269d607a0e9232f783826fc9200f242e5facccfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4892e83083debfd8eeb929269d607a0e9232f783826fc9200f242e5facccfc0"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
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
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
