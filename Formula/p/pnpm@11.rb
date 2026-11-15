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
    sha256 cellar: :any,                 arm64_golden_gate: "d652c48e2919c0e2238c31e22ca2656762208136b7a1369cdb87d039d18f7cb2"
    sha256 cellar: :any,                 arm64_tahoe:       "d652c48e2919c0e2238c31e22ca2656762208136b7a1369cdb87d039d18f7cb2"
    sha256 cellar: :any,                 arm64_sequoia:     "d652c48e2919c0e2238c31e22ca2656762208136b7a1369cdb87d039d18f7cb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d3eb2ec6efa6c0cd4c658f5e9cc431e23f147ba88e95b1fbd026eab3cc7fda4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8d3eb2ec6efa6c0cd4c658f5e9cc431e23f147ba88e95b1fbd026eab3cc7fda4"
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
