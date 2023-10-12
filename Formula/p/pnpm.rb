class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.9.0.tgz"
  sha256 "8f5264ad1d100da11a6add6bb8a94c6f1e913f9e9261b2a551fabefad2ec0fec"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8bf4b23c311638d3746a44c880a831adc3ac2251b664daea757f6a15ea06168f"
    sha256 cellar: :any,                 arm64_ventura:  "8bf4b23c311638d3746a44c880a831adc3ac2251b664daea757f6a15ea06168f"
    sha256 cellar: :any,                 arm64_monterey: "8bf4b23c311638d3746a44c880a831adc3ac2251b664daea757f6a15ea06168f"
    sha256 cellar: :any,                 sonoma:         "f6a01095f7d6d8a0553a045c6bf31c548185088c3dd02ea658f6efaa71ee2e67"
    sha256 cellar: :any,                 ventura:        "f6a01095f7d6d8a0553a045c6bf31c548185088c3dd02ea658f6efaa71ee2e67"
    sha256 cellar: :any,                 monterey:       "f6a01095f7d6d8a0553a045c6bf31c548185088c3dd02ea658f6efaa71ee2e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda38714d33b3f8603e0aa328deb14637a091a0ba28f6f14d9ac1a298e110fac"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
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
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
