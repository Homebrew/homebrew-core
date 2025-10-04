class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.18.0.tgz"
  sha256 "3967a3efe2909df305fec4b833a304dfca17c380b6bb77672f4dac4f2cdd3788"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "902c6cf6d5adeba127d461870fb3ea704511fc0d491b6ca040a941c98d1f5db3"
    sha256 cellar: :any,                 arm64_sequoia: "ed523d296ffce2c67bb1465c701abff414814759eeb9660bdd30716115daa36d"
    sha256 cellar: :any,                 arm64_sonoma:  "ed523d296ffce2c67bb1465c701abff414814759eeb9660bdd30716115daa36d"
    sha256 cellar: :any,                 sonoma:        "1940300d965fdda4fbbad40fe080efd2c67275e935b3601f18244e05af4941ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5afd4c3417c0e56c423fcf73103b98ac69f12b41759756b2df78891306df2d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5afd4c3417c0e56c423fcf73103b98ac69f12b41759756b2df78891306df2d57"
  end

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
