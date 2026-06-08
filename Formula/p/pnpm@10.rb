class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.1.tgz"
  sha256 "b568bc5ee2b68a9735743c1b9f09b3d3065de64befaf186c5d01b2f084d16cc0"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36a02a1b34cf0fa4ab3d60abdfba05dc858935e2086872539c2538c9dd6ceda6"
    sha256 cellar: :any,                 arm64_sequoia: "8292b9d59175ec437135dbf2879f9a4a6ffa8bc23f0fc0ff4405ffcf2aafb68f"
    sha256 cellar: :any,                 arm64_sonoma:  "8292b9d59175ec437135dbf2879f9a4a6ffa8bc23f0fc0ff4405ffcf2aafb68f"
    sha256 cellar: :any,                 sonoma:        "c3a0e7239cb62faebc8d0cc58198e8242ce2ce513582eaed96dfa0aa3ab72262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfd4be941f81da4bc8552ed23e9371e5847431d272473fc75dd0e1ea1bd64cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd4be941f81da4bc8552ed23e9371e5847431d272473fc75dd0e1ea1bd64cb3"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@10"
    bin.install_symlink bin/"pnpx" => "pnpx@10"

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
