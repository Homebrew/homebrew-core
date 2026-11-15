class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.9.tgz"
  sha256 "7e8a946108e7baab119e51d27c24d6178b46545422643dbc91e34e2f1ee32e0f"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "7b8c2bae8923f5beda8d282c18730e2e7f000c87c65e14794c734a834cc048e0"
    sha256 cellar: :any,                 arm64_tahoe:       "7b8c2bae8923f5beda8d282c18730e2e7f000c87c65e14794c734a834cc048e0"
    sha256 cellar: :any,                 arm64_sequoia:     "7b8c2bae8923f5beda8d282c18730e2e7f000c87c65e14794c734a834cc048e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d5bbd16904188243aa00aeabe6973cfd89f40ccb711632e141a7ac018ddd9afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d5bbd16904188243aa00aeabe6973cfd89f40ccb711632e141a7ac018ddd9afa"
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
