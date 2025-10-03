class Jrsonnet < Formula
  desc "Rust implementation of Jsonnet language"
  homepage "https://github.com/CertainLach/jrsonnet"
  url "https://github.com/CertainLach/jrsonnet/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "2396c57a49a20db99da17b8ddd1b0b283f1a6e7c5ae1dc94823e7503cbb6ce3f"
  license "MIT"
  head "https://github.com/CertainLach/jrsonnet.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "026bf62a8f25bba0ebb74716c7167c4564c69967bf4860a64e81332ca668c187"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "84d48f262c1a5d6c4c8054bc435c7ed3c125ea6eff0ac44758c4d6d5d7a902be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8612efbafac8310f5542bc1a928c064853db67955dfd30c7678afa8d21ef9fbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d0249acf621ed487cffb828cc63c2210749a30de553f0f0cb48c9b00a15c545"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "662dbf19789e9f681e4c325d2814b1e77ef88174e6b9083d6793192bd5ac1523"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66be41438ed1da22c922c59d3da10a1852b89491898881c2bcd25c114abd4852"
    sha256 cellar: :any_skip_relocation, sonoma:         "b149496a8055b9dffca8be4eb576f62af266ac219c7010603924fca8ddd06f79"
    sha256 cellar: :any_skip_relocation, ventura:        "9fc6a73c2b9c251038f317bef54054b598620d687872ccae2da6cad585ecb14d"
    sha256 cellar: :any_skip_relocation, monterey:       "89080991d6ec832d7fa2d868a4323e08921291a01100797a7343790b3ab30088"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e96db079868f110cd8b9fc4b29a1340bd5539ab1740928d8c2a8d8a7c34b25e"
    sha256 cellar: :any_skip_relocation, catalina:       "fbbaf136a231569a619722188c22fed49d586431ee1a1515e9cfc84bac0eafd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a2c0b31f422bd414ea9a03f66e47131e10513157ce995499770e364a6b944692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a04748fc43150da3210809034f82864313d7706869ec78265462a22cf2a4812"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cmds/jrsonnet")
    if build.head?
      generate_completions_from_executable(bin/"jrsonnet", "generate")
    else
      generate_completions_from_executable(bin/"jrsonnet", "-", "--generate")
    end
  end

  test do
    assert_equal "2\n", shell_output("#{bin}/jrsonnet -e '({ x: 1, y: self.x } { x: 2 }).y'")
  end
end
