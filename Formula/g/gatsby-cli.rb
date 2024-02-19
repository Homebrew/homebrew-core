require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.13.2.tgz"
  sha256 "a987749ef9abbef2f99ef334347562d81fce7a47c95e2b5f40c526b544410dbf"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "70ff3794fb5b2ec22c171640a191762d010317917c77395e88eb3ae8e2a6b056"
    sha256                               arm64_ventura:  "3c1213c82a87b0ab2f49b3411df0b7073f28ae50162a1f058345f0e2a11906d6"
    sha256                               arm64_monterey: "b9ab1c1043ac34c16df2a9a1ffa0250ea6828587d567315e11b4667d91b38c9a"
    sha256                               sonoma:         "541cc6d90fddda1da44f95dd96203257a69ac705af34579fd9e654e6e954a287"
    sha256                               ventura:        "f64191d280edb2f464dbbf621aedecd502f02552c2a22630a5f1cc483fd299d1"
    sha256                               monterey:       "8ea519ece53c54191a9849e3d0547c653869367fdea581103c101dae3a1d3730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a884d24829fb5ee09ab696402d7e230a44a361ef0bbd04f711afa3e3f4823f"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
