class PnpmAT9 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.9.tgz"
  sha256 "cf86a7ad764406395d4286a6d09d730711720acc6d93e9dce9ac7ac4dc4a28a7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-9"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "065dfbb68112b1fa1f55b86a0e575944b20811fe2e50a9dc87761c88067d232d"
    sha256 cellar: :any,                 arm64_sequoia: "ae74b37d814b99dd613cb07f94b593dab2bb1dca09ff9ade108ff180aba53db5"
    sha256 cellar: :any,                 arm64_sonoma:  "ae74b37d814b99dd613cb07f94b593dab2bb1dca09ff9ade108ff180aba53db5"
    sha256 cellar: :any,                 arm64_ventura: "ae74b37d814b99dd613cb07f94b593dab2bb1dca09ff9ade108ff180aba53db5"
    sha256 cellar: :any,                 sonoma:        "4ecc62fb50f7704d9afa60dc3e161ec772c59f85d0df91808813f26bd7fe3ace"
    sha256 cellar: :any,                 ventura:       "4ecc62fb50f7704d9afa60dc3e161ec772c59f85d0df91808813f26bd7fe3ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b604d8e5694ed2c72031680e1ad2a3b56a88dc9a808c6714f47969ecd7ccd02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b604d8e5694ed2c72031680e1ad2a3b56a88dc9a808c6714f47969ecd7ccd02d"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@9"
    bin.install_symlink bin/"pnpx" => "pnpx@9"

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
