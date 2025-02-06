class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.2.0.tgz"
  sha256 "72f1630812107c8723eb5be4517725f3e13f09cfd8f71571cf29f23ce318bdb7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33387b2eebd72a039d7a5ec203df0a049d8a6ad7994a630141c589f9a262f2d7"
    sha256 cellar: :any,                 arm64_sonoma:  "33387b2eebd72a039d7a5ec203df0a049d8a6ad7994a630141c589f9a262f2d7"
    sha256 cellar: :any,                 arm64_ventura: "33387b2eebd72a039d7a5ec203df0a049d8a6ad7994a630141c589f9a262f2d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "30741ee47859b6c8466320907cdf71b2c02327e89be8210f8a0655f2d22a72f0"
    sha256 cellar: :any_skip_relocation, ventura:       "30741ee47859b6c8466320907cdf71b2c02327e89be8210f8a0655f2d22a72f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84865de86d40e8581ad83df56b81d3a182f5515ee9c6e072237d47113f3ce7ea"
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
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
