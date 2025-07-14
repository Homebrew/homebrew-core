class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.80.0.tgz"
  sha256 "7264d2dd2772479cc57d8acc5ba79f40383e5c4e062d1b67002c067c39f39135"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ee0ed149321d9d826740c53336ad65cd16ae09ba29ae75d85eda291aada3ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee0ed149321d9d826740c53336ad65cd16ae09ba29ae75d85eda291aada3ff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ee0ed149321d9d826740c53336ad65cd16ae09ba29ae75d85eda291aada3ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc40fc5e95556c027dace145e363da33f846c4765dc5d9ad87701a087bda5c22"
    sha256 cellar: :any_skip_relocation, ventura:       "bc40fc5e95556c027dace145e363da33f846c4765dc5d9ad87701a087bda5c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ee0ed149321d9d826740c53336ad65cd16ae09ba29ae75d85eda291aada3ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ee0ed149321d9d826740c53336ad65cd16ae09ba29ae75d85eda291aada3ff8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = File::NULL
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~JSON
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    JSON
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end
