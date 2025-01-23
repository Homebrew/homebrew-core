class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "2452a5a428218bf47c68e4176e65aa192681e7d69acc004d3cfc3741e2a3bbc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b512a4689cf7988db396e17090218487836954ca2eb76e494356284b959326c6"
  end

  depends_on "node"

  uses_from_macos "zlib"

  def install
    # Install `devDependency` packages to compile the TypeScript files
    system "npm", "install", *std_npm_args(prefix: false), "-D"
    system "npm", "run", "build"

    # NOTE: We have to manually install `typescript` along with the package
    # dependencies because it's `require`d in `TscUtils.js` but is only
    # specified as a `devDependency`.
    system "npm", "install", *std_npm_args, "typescript"
    bin.install_symlink Dir["#{libexec}/bin/astgen"]
  end

  test do
    (testpath/"main.js").write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match "\"fullName\":\"#{testpath}/main.js\"", (testpath/"out/main.js.json").read
    assert_match '"0":"Console"', (testpath/"out/main.js.typemap").read
  end
end
