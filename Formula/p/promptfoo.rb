class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.112.3.tgz"
  sha256 "355a03076a796e3c11d8cfb58e714e6670d427b54d381b44341131e51c51a241"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d19e994971aaa0cccd8ceeb4915ad55f5b577474222feded4d060ea09b3a7a99"
    sha256 cellar: :any,                 arm64_sonoma:  "4eb7369e8992b3c97db4fe4a0b118695aec37ac29ffa6154664a1686957095d4"
    sha256 cellar: :any,                 arm64_ventura: "9c84eed6c5e3bdeab021e96a4263be26f41622450deccf5a40891f4e6f499b73"
    sha256                               sonoma:        "7b8002637dc201e992bb149c5274c9da827b1552959ac544d2a15d5363297779"
    sha256                               ventura:       "8c34a642b9b67e15ac6477dee849ac2c6531b8c6e8780d6fda9dc1b9cbbcfb77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4568a08eb6fe69e6399f9e890a3a528513c36df0720a9d69630a05dcaa6435a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b099010865093355d20b378d1fdd72068da4a2ba5c66abcd9c512eed34d3587"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
