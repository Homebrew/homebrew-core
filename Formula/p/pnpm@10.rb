class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.5.tgz"
  sha256 "ccb5c479cab1b00621325bfe7d4c9a8a8031e7a525d7249e275ecbec81b08db2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35da6766500f72d05bf91959b63d084a25f27033ddecfb54d46d45820580cee0"
    sha256 cellar: :any,                 arm64_sequoia: "024eb99f33594ece6933b896179e28120a61e0112c8eb696e775f066c3c5d90a"
    sha256 cellar: :any,                 arm64_sonoma:  "024eb99f33594ece6933b896179e28120a61e0112c8eb696e775f066c3c5d90a"
    sha256 cellar: :any,                 sonoma:        "42120517ebb98f344cda03e06b79bb539f29753f5d789de0abd2cceb1cdd926d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60cda998763d2d2e30c62f99a3f39b92583e1cbdafe8fd5fc6f7270e8493f541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60cda998763d2d2e30c62f99a3f39b92583e1cbdafe8fd5fc6f7270e8493f541"
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
