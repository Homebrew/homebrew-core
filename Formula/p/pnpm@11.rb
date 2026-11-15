class PnpmAT11 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.28.12.tgz"
  sha256 "d0c42f9232c9685056b432f8b07631bbabd245d40ede9a982919c7a7ada40aa7"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5a4c3463fccdd99278d1249e25beaf97f6ced80d71ec154e968d0867eff2092f"
    sha256 cellar: :any,                 arm64_tahoe:       "5a4c3463fccdd99278d1249e25beaf97f6ced80d71ec154e968d0867eff2092f"
    sha256 cellar: :any,                 arm64_sequoia:     "5a4c3463fccdd99278d1249e25beaf97f6ced80d71ec154e968d0867eff2092f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7e22ec0ae1fe20fb22f786a8d3c7a1fd48f260f7599ee27ddc51b29ce192a8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7e22ec0ae1fe20fb22f786a8d3c7a1fd48f260f7599ee27ddc51b29ce192a8f2"
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
