class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-10.0.0.tgz"
  sha256 "b1f718e4d63d600c42bbb52f7b93e60f92e2973be723119f4a47dbb5f77b110e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd4c53aae9a4d5fec840dd0ce93b9b342297832146de16a39dec6730896368d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dd4c53aae9a4d5fec840dd0ce93b9b342297832146de16a39dec6730896368d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dd4c53aae9a4d5fec840dd0ce93b9b342297832146de16a39dec6730896368d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d29451eded524c07a0971fbc0b08a6585eea6452386294161fb62b709ecc11d"
    sha256 cellar: :any_skip_relocation, ventura:       "4d29451eded524c07a0971fbc0b08a6585eea6452386294161fb62b709ecc11d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b397b5769ecddb911acc5e833fcb19af342b15b83a07e8e85ab4116ed4a54ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dd4c53aae9a4d5fec840dd0ce93b9b342297832146de16a39dec6730896368d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi love 2>/dev/null")
    assert_match version.to_s, shell_output("#{bin}/fanyi --version")
  end
end
