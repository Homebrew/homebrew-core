class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.3.tgz"
  sha256 "1c40544020a2e633068ed43a98eb5c0fed7d64a1c6d6f2382e43df91419dad62"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47092ac40ab86356b3af27a65e181a2bd0ed35f7ab363e9d97da6b38758daef3"
    sha256 cellar: :any,                 arm64_sequoia: "5b10742ea61bdd462274ebaca0205731f7ae390dec59a3bf4b572f8874ff55e1"
    sha256 cellar: :any,                 arm64_sonoma:  "5b10742ea61bdd462274ebaca0205731f7ae390dec59a3bf4b572f8874ff55e1"
    sha256 cellar: :any,                 sonoma:        "7dfbee8d5f8c7387bd79acc378fa31e3f6b3b10a156d84cdccc978ca098c1002"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2686c3209b190b928e90613f3e29088ead8ce00b4b2d62419fac00e404fce3bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2686c3209b190b928e90613f3e29088ead8ce00b4b2d62419fac00e404fce3bd"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@10"
    bin.install_symlink bin/"pnpx" => "pnpx@10"

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
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
