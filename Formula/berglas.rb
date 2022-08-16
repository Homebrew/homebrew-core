class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.7.0.tar.gz"
  sha256 "180969b777c0fafe5036acf64d44a3cfc39f484b0b7710cd3bf27dc6af8ff2b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef46970bfa5f3b8801dbe3cb18aff018968f601ba1c327c8ce69a0df2e525660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3da4578702bfdf22a2ae4e3a89c940f2b6463dce07ed537d5fb69fc0e6ec73e"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2c4e9c3cbdd4d4696ace84172b88bc0cfb272e809aa83cac279ed0a9c05798"
    sha256 cellar: :any_skip_relocation, big_sur:        "7986a1b7dbb750be9f68ef9fc32d91475d2269e17321d7edbcf11989f28777fe"
    sha256 cellar: :any_skip_relocation, catalina:       "39b77baa45fa98187622e2015488fb820a01cf758ec3593cb1e9622880a47dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a19beb7482684ffda2c5c2d5553f2f8516b22f647d0e531d778a004158389ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
