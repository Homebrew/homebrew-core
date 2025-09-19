class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.9.0.tar.gz"
  sha256 "4fd9b49943ef916c88b6bcac5281060c99d73963c1e038eba4388064791eebc7"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f8dfa139234bb0126147e523b112384ac77cd12ec0cbe9cf5eb7e467e86c8d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc940179266e2d5afb1a005ecd360268ef27d451f5cb39620e37ba3f23083aab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31c17c40f98d9df20e7ff76006b997822ec9beb3c56788b43414a775b5f95842"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a2f93295eb73500bed65298d844ee5a7e2b6a39731df672ec00d3cd42cdb7af"
    sha256 cellar: :any_skip_relocation, sonoma:        "5eaec72c0d3f6138832c52884f6ff0d426c05734962eb18d3a193852831f669a"
    sha256 cellar: :any_skip_relocation, ventura:       "5c377bf68d5fe5dbff55e9992173b405bca9a9c4d3b420d4a8363d347003ad77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d32510543cb1d0ac627e8bb48c75166ea341564ac2f344fe3bfe6351442e0137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b875e887e2069cb92a2c2e0aa04ce4b07014e4b3ebf186c813a6f910a2cba7f"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_path_exists testpath/"helloworld.tar.gz"
  end
end
