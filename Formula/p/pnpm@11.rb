class PnpmAT11 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.28.6.tgz"
  sha256 "5b047856d727fe3f4e0cbcc216122bddbff3c6d79a3b766d69e5d3b0b92097dc"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8ff5ed138f60b778198e019bed1b703e029e9d1cf3a780629c8390142fe2b609"
    sha256 cellar: :any,                 arm64_tahoe:       "8ff5ed138f60b778198e019bed1b703e029e9d1cf3a780629c8390142fe2b609"
    sha256 cellar: :any,                 arm64_sequoia:     "8ff5ed138f60b778198e019bed1b703e029e9d1cf3a780629c8390142fe2b609"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd217cfa45f45ca0b4e20138d9b70bfc6fd10bf268600b60f88899522b4b1b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fd217cfa45f45ca0b4e20138d9b70bfc6fd10bf268600b60f88899522b4b1b98"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  # downloads npm packages during install
  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@11"
    bin.install_symlink bin/"pnpx" => "pnpx@11"

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
