class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.103.1.tgz"
  sha256 "888b36da102e27ac8e9c010e62d7383d06ce25e988f1d26007763883389a66bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e27e195d304c8ed2f4481f59a3da2b2195ed88f63510cf6f3a5ec84d8e372836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e27e195d304c8ed2f4481f59a3da2b2195ed88f63510cf6f3a5ec84d8e372836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27e195d304c8ed2f4481f59a3da2b2195ed88f63510cf6f3a5ec84d8e372836"
    sha256 cellar: :any_skip_relocation, sonoma:        "a295491283f6c1551501c94e92561599e86215b0fb99dc7b0cf903eed2a76fb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13db3fc8beaa7aa9e36e9714fe06b8122aad4a1d8da653d57abe4359416db50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7056c8302f8cc6f595c534332d49bf9f76cc7430fab130e445c40bf185805556"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
