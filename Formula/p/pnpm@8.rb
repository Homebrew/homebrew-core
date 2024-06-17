class PnpmAT8 < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.8.tgz"
  sha256 "691fe176eea9a8a80df20e4976f3dfb44a04841ceb885638fe2a26174f81e65e"
  license "MIT"
  revision 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-8"
    regex(/["']version["']:\s*?["'](8[^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e5f78f2649e82f81a52b64155c981710d582aa8ce3431e9acdc029e6b338bf5"
    sha256 cellar: :any,                 arm64_ventura:  "6e5f78f2649e82f81a52b64155c981710d582aa8ce3431e9acdc029e6b338bf5"
    sha256 cellar: :any,                 arm64_monterey: "6e5f78f2649e82f81a52b64155c981710d582aa8ce3431e9acdc029e6b338bf5"
    sha256 cellar: :any,                 sonoma:         "02606673fcfd5d5a8bcfcfeac8fd4fa53e778fab5d71044cfdc4f7efe6b947a4"
    sha256 cellar: :any,                 ventura:        "02606673fcfd5d5a8bcfcfeac8fd4fa53e778fab5d71044cfdc4f7efe6b947a4"
    sha256 cellar: :any,                 monterey:       "02606673fcfd5d5a8bcfcfeac8fd4fa53e778fab5d71044cfdc4f7efe6b947a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd87bf2b969e693605590e9689a126d6653418541b5a70bd4b283717b1e3d83"
  end

  keg_only :versioned_formula

  disable! date: "2025-04-30", because: :unmaintained

  depends_on "node" => [:build, :test]

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm@8"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx@8"
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    generate_completions_from_executable(bin/"pnpm", "completion")

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
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
