class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.25.3.tgz"
  sha256 "39b761c81a6d1d65819ea2f30e96965e25e7ada6d14644e449116e9543b4619f"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b404362efc90f2ce7986adc01878db41f9142dee34a9c32785ed43438902e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b404362efc90f2ce7986adc01878db41f9142dee34a9c32785ed43438902e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b404362efc90f2ce7986adc01878db41f9142dee34a9c32785ed43438902e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "25b404362efc90f2ce7986adc01878db41f9142dee34a9c32785ed43438902e0"
    sha256 cellar: :any_skip_relocation, ventura:        "25b404362efc90f2ce7986adc01878db41f9142dee34a9c32785ed43438902e0"
    sha256 cellar: :any_skip_relocation, monterey:       "25b404362efc90f2ce7986adc01878db41f9142dee34a9c32785ed43438902e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc9d301c9ecf59636baf5e2a42601ce6712915c601360158ddd54cf5e9d3fb4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = pipe_output("#{bin}/prettierd test.js", "const arr = [1,2];", 0)
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
