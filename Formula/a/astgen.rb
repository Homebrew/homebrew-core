class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v3.37.0.tar.gz"
  sha256 "bc41e4b04886047350b1db1cfe303b4ded6f243b3a094b1c42304f08ffa5732d"
  license "Apache-2.0"
  head "https://github.com/joernio/astgen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "aa0d4c0a0efca61052f9c3672634b339b98e4d697653d119c4cc8610ed01b1db"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Install `devDependency` packages to compile the TypeScript files
    system "npm", "install", *std_npm_args(prefix: false), "-D"
    system "npm", "run", "build"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
