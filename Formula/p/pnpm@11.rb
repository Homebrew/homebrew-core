class PnpmAT11 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.27.1.tgz"
  sha256 "d50f8841e67ef0b1d82e7c90b240656c7ca04d5f1aa33f06108007c81fd76766"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5a67758e4f0aef405ff6be4cd80b413717cc65ea8379bbfe4cdb1b23e415d246"
    sha256 cellar: :any,                 arm64_tahoe:       "5a67758e4f0aef405ff6be4cd80b413717cc65ea8379bbfe4cdb1b23e415d246"
    sha256 cellar: :any,                 arm64_sequoia:     "5a67758e4f0aef405ff6be4cd80b413717cc65ea8379bbfe4cdb1b23e415d246"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f53a7cd787a746f46c7806368419531081b5324e9ddee644c87d40919518a3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f53a7cd787a746f46c7806368419531081b5324e9ddee644c87d40919518a3b2"
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
