class PnpmAT11 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.29.0.tgz"
  sha256 "2910b640d6504f682a11b4b3bca9668ff812d41dd7a23cd1596944c44214db71"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "0b3da004bc1c7a7488f40c4d5e429dd860dd727576103de50f8c7e464cd14c91"
    sha256 cellar: :any,                 arm64_tahoe:       "0b3da004bc1c7a7488f40c4d5e429dd860dd727576103de50f8c7e464cd14c91"
    sha256 cellar: :any,                 arm64_sequoia:     "0b3da004bc1c7a7488f40c4d5e429dd860dd727576103de50f8c7e464cd14c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d699d770ad65be0b04b5d83818bc10001f3f754c5f8b322060d1fa2c91520a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d699d770ad65be0b04b5d83818bc10001f3f754c5f8b322060d1fa2c91520a7"
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
