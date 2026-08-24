class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.47.0.tar.gz"
  sha256 "471a1c6392fd620a153e64d5755f84e1ce0251315020bb1b80243ad9e038c2fb"
  license "Apache-2.0"
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cecdb58c1cbee3ab8a97cea19079b401fe2da5fc4f241b0ba0b68b713e4c38d0"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    cd "javascript-astgen" do
      # Install `devDependency` packages to compile the TypeScript files
      system "npm", "install", *std_npm_args(prefix: false), "-D"
      system "npm", "run", "build"

      system "npm", "install", *std_npm_args
      bin.install_symlink libexec.glob("bin/*")
    end
  end

  test do
    (testpath/"main.js").write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match "\"fullName\":\"#{testpath}/main.js\"", (testpath/"out/main.js.json").read
    assert_match '"0:7":"Console"', (testpath/"out/main.js.typemap").read
  end
end
