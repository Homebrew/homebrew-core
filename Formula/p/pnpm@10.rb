class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.7.tgz"
  sha256 "c729f6538e005d234889910466fd1c4c44affb0b28ea86d93fcf88aa1aefa694"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c2a427f51a6ac825ddb2dd46a99d06e5268c1d5743596d21372d5675ee16049e"
    sha256 cellar: :any,                 arm64_tahoe:       "c2a427f51a6ac825ddb2dd46a99d06e5268c1d5743596d21372d5675ee16049e"
    sha256 cellar: :any,                 arm64_sequoia:     "c2a427f51a6ac825ddb2dd46a99d06e5268c1d5743596d21372d5675ee16049e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a878979d20b5c17a7fdd302e23f1ce848d5a5936225861d72a46d7c0629905b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a878979d20b5c17a7fdd302e23f1ce848d5a5936225861d72a46d7c0629905b4"
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
