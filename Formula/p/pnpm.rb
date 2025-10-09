class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.18.2.tgz"
  sha256 "93421022fe0156d7cbdf699edc3d7eab39654986eac14f927d02b85f0dac6d61"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a180992ff53d48ce3141bfa51780236b346b63ef4a763fa905b894e34224e8a"
    sha256 cellar: :any,                 arm64_sequoia: "b984d07bf8f6a75bf3e2ce2df0f985b24a36eeb164da7a292e9c95b81a00cddb"
    sha256 cellar: :any,                 arm64_sonoma:  "b984d07bf8f6a75bf3e2ce2df0f985b24a36eeb164da7a292e9c95b81a00cddb"
    sha256 cellar: :any,                 sonoma:        "99d1d402223741dbf496f6b4c93200aa24df5c09a1c13d93856e3040d8656d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcdc0f71a07f9d7b23665c340efd3a4b110f37ae099b44ca47a8b974ff4edfb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcdc0f71a07f9d7b23665c340efd3a4b110f37ae099b44ca47a8b974ff4edfb5"
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
