class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.5.2.tgz"
  sha256 "749dc54fbd3dcde9e414baae32c177ca84770d3fcd69c8816d579adc3e6a2c99"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ced1d3d804dbb9c0adcedc9afdfff0f218e6fc8907186b95db5758fe0b103b2"
    sha256 cellar: :any,                 arm64_sequoia: "9b47eeb2d0aecebef63f60c404a57115970204f73691e5983ac872ead2e95778"
    sha256 cellar: :any,                 arm64_sonoma:  "9b47eeb2d0aecebef63f60c404a57115970204f73691e5983ac872ead2e95778"
    sha256 cellar: :any,                 sonoma:        "081b6612535d6b38c79a55e93318201f1e157524c09e3627b727699e2f2f00c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a49b3a62e3ff626719e8c9cac14c6b78e05556f0730e7cc0f2ac4580b30901dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49b3a62e3ff626719e8c9cac14c6b78e05556f0730e7cc0f2ac4580b30901dc"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
