class PnpmAT9 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.5.tgz"
  sha256 "8472168c3e1fd0bff287e694b053fccbbf20579a3ff9526b6333beab8df65a8d"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-9"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a14edc4c5936edf1a0b69cbe7d17e8f986f4a7ec31e0bc753edbb416515bb05f"
    sha256 cellar: :any,                 arm64_sonoma:  "a14edc4c5936edf1a0b69cbe7d17e8f986f4a7ec31e0bc753edbb416515bb05f"
    sha256 cellar: :any,                 arm64_ventura: "a14edc4c5936edf1a0b69cbe7d17e8f986f4a7ec31e0bc753edbb416515bb05f"
    sha256 cellar: :any,                 sonoma:        "8fb5d101ba37272a2f65d6a158ebf3f6bbc9ec380c72640995579a1d70b39628"
    sha256 cellar: :any,                 ventura:       "8fb5d101ba37272a2f65d6a158ebf3f6bbc9ec380c72640995579a1d70b39628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e97c287d43c9095a6792cc9cf29ef14e084bd3669b6fec4ea7ce5e3d7b8963"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@9"
    bin.install_symlink bin/"pnpx" => "pnpx@9"

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
