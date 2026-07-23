class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://garden-rs.gitlab.io"
  url "https://github.com/garden-rs/garden/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "9b7abd9f5d1884b630cec29c993432c730a731fd71e25018c7e5921d87e0f5a2"
  license "MIT"
  head "https://github.com/garden-rs/garden.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a9b29276037278aa7a956166e4b73c37b996802f0ccac71e07848311682910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0036592c037335eb739f5432e688d47897f56f1ba14c4a2db45dd5ee6046eab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51f6e9960cf16c255ce953f100ca570d7df0b8506a7bfaf095dfdc0316c70170"
    sha256 cellar: :any_skip_relocation, sonoma:        "44bcb4f7bc13537fe6076d0dff0b797a895527d1866016a2caa5ee391d67a5d0"
    sha256 cellar: :any,                 arm64_linux:   "935a1f4648f3930ee500dbc53e333fb5b62604ff4e5c5a308116416df3ec14fc"
    sha256 cellar: :any,                 x86_64_linux:  "3f4a10e4f4bbf652fea4a154bb86a7a455a4f8a466db405179ef80e248a0e713"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "gui")
  end

  test do
    (testpath/"garden.yaml").write <<~YAML
      trees:
        current:
          path: ${GARDEN_CONFIG_DIR}
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${filename}
      variables:
        filename: $ echo output
    YAML
    system bin/"garden", "-vv", "test", "current"
    assert_path_exists testpath/"current"
    assert_path_exists testpath/"output"
  end
end
