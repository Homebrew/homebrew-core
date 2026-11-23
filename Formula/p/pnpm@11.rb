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
    manifest_sha256 "56815dd3c8293e15f416bbe81ceca6614dc5a0d4890b04f83ab151e63740482d"
    sha256 cellar: :any,                 arm64_golden_gate: "3c0da2b71bd0baf3b737b50735d41cea3d8b7445c2248cb75672f871e1102c4c"
    sha256 cellar: :any,                 arm64_tahoe:       "3c0da2b71bd0baf3b737b50735d41cea3d8b7445c2248cb75672f871e1102c4c"
    sha256 cellar: :any,                 arm64_sequoia:     "3c0da2b71bd0baf3b737b50735d41cea3d8b7445c2248cb75672f871e1102c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c60b52df640bb6d73c39d339f21a1f5407e524e408b098a9a519628ff0fc3ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c60b52df640bb6d73c39d339f21a1f5407e524e408b098a9a519628ff0fc3ecf"
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
