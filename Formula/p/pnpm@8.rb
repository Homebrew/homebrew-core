class PnpmAT8 < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.8.tgz"
  sha256 "691fe176eea9a8a80df20e4976f3dfb44a04841ceb885638fe2a26174f81e65e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-8"
    regex(/["']version["']:\s*?["'](8[^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ea3d022f62b7c059c40cd981745b4324a14629f9970044328cccc25c527a433d"
    sha256 cellar: :any,                 arm64_ventura:  "ea3d022f62b7c059c40cd981745b4324a14629f9970044328cccc25c527a433d"
    sha256 cellar: :any,                 arm64_monterey: "ea3d022f62b7c059c40cd981745b4324a14629f9970044328cccc25c527a433d"
    sha256 cellar: :any,                 sonoma:         "9e9b7d9c654a0a5c5b3e820f105e05470319df38f85c184382c77cf63f1fc725"
    sha256 cellar: :any,                 ventura:        "9e9b7d9c654a0a5c5b3e820f105e05470319df38f85c184382c77cf63f1fc725"
    sha256 cellar: :any,                 monterey:       "9e9b7d9c654a0a5c5b3e820f105e05470319df38f85c184382c77cf63f1fc725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0583db90f4ca28448506dec0cbce2d21b9d57fd157eed46ae985a1528f4244c3"
  end

  keg_only :versioned_formula

  disable! date: "2025-04-30", because: :unmaintained

  depends_on "node" => [:build, :test]

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm@8"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx@8"

    generate_completions_from_executable(bin/"pnpm@8", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm@8 requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm@8", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
