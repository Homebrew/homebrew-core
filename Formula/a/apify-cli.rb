class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.4.tgz"
  sha256 "450a4e95a349e8b9c260db74ff652871551a07484bffbfe7a55c71c473727757"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e92ac7e704f14843a420d54b9581a8455966c8eca672ae09c1729b5cc87463f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e92ac7e704f14843a420d54b9581a8455966c8eca672ae09c1729b5cc87463f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e92ac7e704f14843a420d54b9581a8455966c8eca672ae09c1729b5cc87463f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "46367531bc139f3ebae7c15a09322a7243e26a9f752cd54fe41056f38df9250c"
    sha256 cellar: :any_skip_relocation, ventura:       "46367531bc139f3ebae7c15a09322a7243e26a9f752cd54fe41056f38df9250c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a438bd6c9c990f1889f9cde5aed52e8d419511797984357df477dc6bef0a7dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a438bd6c9c990f1889f9cde5aed52e8d419511797984357df477dc6bef0a7dcc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
