class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.0.8.tgz"
  sha256 "7d73b1a9e413cde021551917fa25995b59011c3ca628ed0ad09e1e117001a7aa"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b577511c50965771455c7298dc29335f5893e7489548b9b625701ffa76d3f151"
    sha256 cellar: :any,                 arm64_sequoia: "8688813744aa1dc501f9bea31ead1275b3afa1608273a7554e9b785655dba801"
    sha256 cellar: :any,                 arm64_sonoma:  "8688813744aa1dc501f9bea31ead1275b3afa1608273a7554e9b785655dba801"
    sha256 cellar: :any,                 sonoma:        "5f47f2d56dcd4345cbdb8a2120eaa23d09f3ad9acc736c3787be15d7d248b92d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c502b76396c5f8a5375229a0e0d378b166f05012c0372b00acaa5a1af7ad95fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c502b76396c5f8a5375229a0e0d378b166f05012c0372b00acaa5a1af7ad95fe"
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
