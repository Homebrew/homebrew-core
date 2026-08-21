class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://garden-rs.gitlab.io"
  url "https://github.com/garden-rs/garden/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "3c5e41cbc0106576762b6456b223bfb173ddadc8df3b81af2491883b60821b75"
  license "MIT"
  head "https://github.com/garden-rs/garden.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd1f509d71042bb9d37704eac5279bc527e85102c5d12ebdaffc2248a986d232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dbc97a78c3a3eff58eabbfd8d7f02d0daec49882350c89404fde7e1e18856ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89cfe7b336f889a105a9a380d4c6f38b750ca5db99b34332f93188233ccc356d"
    sha256 cellar: :any_skip_relocation, sonoma:        "59bcdb5ddebc889de902a66c096c0fabfe7dec66663a1ff1bc6f38e44c259f35"
    sha256 cellar: :any,                 arm64_linux:   "98a78e779ae374e554777c724faf2350b273aac13d153650c3cd49157277c9ea"
    sha256 cellar: :any,                 x86_64_linux:  "52e0002ebef0bb20cd64432e37c18818265ea53d109b9a86318bfa3942b349ef"
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
