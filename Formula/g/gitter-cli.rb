class GitterCli < Formula
  desc "Extremely simple Gitter client for terminals"
  homepage "https://github.com/RodrigoEspinosa/gitter-cli"
  url "https://github.com/RodrigoEspinosa/gitter-cli/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "c4e335620fc1be50569f3b7543c28ba2c6121b1c7e6d041464b29a31b3d84c25"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "87461a9980501e5c6dbed7e5ccb7e4410569a82fb16019ed8a556375eee13601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa9eccb23942bcb3eb0178bba4d6855e5087343bf22750f3b932eb7e752f3a67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa9eccb23942bcb3eb0178bba4d6855e5087343bf22750f3b932eb7e752f3a67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa9eccb23942bcb3eb0178bba4d6855e5087343bf22750f3b932eb7e752f3a67"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9db9eac3088781fc38e0eb469a807562542d97a797986c7e7075f0eacf34c95"
    sha256 cellar: :any_skip_relocation, ventura:        "b9db9eac3088781fc38e0eb469a807562542d97a797986c7e7075f0eacf34c95"
    sha256 cellar: :any_skip_relocation, monterey:       "b9db9eac3088781fc38e0eb469a807562542d97a797986c7e7075f0eacf34c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d362ab733091481c4aa4d761e1d533e1b4c470231f25eeee6ef5cef74cbe0a64"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/gitter-cli"
  end

  test do
    assert_match "access token", pipe_output("#{bin}/gitter-cli authorize")
  end
end
