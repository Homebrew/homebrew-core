require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.64.0.tgz"
  sha256 "db495af69a9ba8ecb61bf3f8e04069e47b0fe4fc470f05abf3e37247cb98a3fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edbf46417f3d2e2c5049721aa4afb8ad00eae296f0e721d1018419e6a1b9aef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848e5c83edb8a3af83ab415a31fe21ace38429dcbd063316525ba073fe25fc5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faa5d5690ee67d474c4836f1ea8080e1fa49d785230339ae45da664e74dc1fac"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa61f06af978d19fca5de9a9fda624f90b689d008e92fb914fc8e523a2382d58"
    sha256 cellar: :any_skip_relocation, ventura:        "949ffc900cd2b4e0607e4a5160ca6802dc8b5c5472dbe2a9fb8c6905d8a5786f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b32c5a6db434067e19bb154b945aa7e191d654147aede7016a23e427fe49421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9fc0aaf13ed2355e40a6175cc68fb6bd1220d09fa8e97e3c8fc2187a3d901d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: 'My eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end
