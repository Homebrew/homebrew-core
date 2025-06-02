class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.com/docs/reference/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.14.0.tgz"
  sha256 "7e2769d985ed6e008fb2c75a57b55c543c44237bc10b289632ddf504d39c35db"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ba1afdda97434e2693af75cc6a9080357ae99ce2617ecc08585fdc17fa044e52"
    sha256                               arm64_sonoma:  "01f93063702b9c6e426d48ed809add8baaf05a4f97c19bb5d6714953fd0c3c79"
    sha256                               arm64_ventura: "c722cc790dc1697fa764ad02594c80cb2b506f84a5da412d5ffc00e2e03a2a3d"
    sha256                               sonoma:        "15744fd268f96a9b7634574cae8037136c25a632d4e1355b736db8fb452050da"
    sha256                               ventura:       "94670b31b65a8cc2bbaa067ad45c5a0de9224365e64185459b5c084b9156f779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c595e92a5bcddd68c2fb37310eec42c83b196b557aa3cda7016a93fb3afedacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03cf15550ff1ed472c2c71bfa7aa1746ea83144e8c56ec675350511f4f4b320"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
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
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    # Workaround for https://github.com/nodejs/node-addon-api/issues/1007
    ENV.append "CXXFLAGS", "-std=c++17" if OS.linux?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_path_exists testpath/"hello-world/package.json", "package.json was not cloned"
  end
end
