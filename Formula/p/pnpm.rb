class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.28.1.tgz"
  sha256 "52128de921542b1faa91c4c7dec5e88c5736ccb6006b879401e90db275ee4719"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bf31396debda4bdfeff12195d6976ac92ebde3bf87390e763c8d8279425e8e8"
    sha256 cellar: :any,                 arm64_sequoia: "7c66f581d40b2c59b313ba3aea815feceef9e80718b256112e0c54dafa3e20d6"
    sha256 cellar: :any,                 arm64_sonoma:  "7c66f581d40b2c59b313ba3aea815feceef9e80718b256112e0c54dafa3e20d6"
    sha256 cellar: :any,                 sonoma:        "849bce619562c97a245f311e2b535549469b60274cf2955c52961123b34f5c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b95d6d66a0b11fdd66a0d46a46370324f3aa2151c857c7271875d5924729fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b95d6d66a0b11fdd66a0d46a46370324f3aa2151c857c7271875d5924729fad"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

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
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
