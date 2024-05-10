class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.1.0.tgz"
  sha256 "22e36fba7f4880ecf749a5ca128b8435da085ecd49575e7fb9e64d6bf4fad394"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f022786cd7d0d5165738acc994675fedc127bc111846607a17a24e95a0294017"
    sha256 cellar: :any,                 arm64_ventura:  "f022786cd7d0d5165738acc994675fedc127bc111846607a17a24e95a0294017"
    sha256 cellar: :any,                 arm64_monterey: "f022786cd7d0d5165738acc994675fedc127bc111846607a17a24e95a0294017"
    sha256 cellar: :any,                 sonoma:         "7cad987b3e771c82a5d806a5ddc64eb825c0f7f73cfca4d0e0a09724294ca75c"
    sha256 cellar: :any,                 ventura:        "7cad987b3e771c82a5d806a5ddc64eb825c0f7f73cfca4d0e0a09724294ca75c"
    sha256 cellar: :any,                 monterey:       "7cad987b3e771c82a5d806a5ddc64eb825c0f7f73cfca4d0e0a09724294ca75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de447861e14c5d27e9d94e5d0e11b5ed0b6eb1be05c537ad93600f0d8495cecc"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
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
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
