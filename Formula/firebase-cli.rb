require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.4.2.tgz"
  sha256 "53912ac166103a57bb0426d299c117d9139fceda3232299ab8056a5bd26d1977"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "3dd838fb3e2fb920f1bc79d6e44035b6f5b88aa431f4ff295c9bf0ba5e6c3827"
    sha256                               arm64_big_sur:  "00c8e7c3d833470b9fc4f2fe759720b6242ea91780d05253bdbf8425f0313340"
    sha256 cellar: :any_skip_relocation, monterey:       "48bb51c269e07eb75f7bf96f2f49b7957ea8c139dad3c9228affad651d59cd7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "48bb51c269e07eb75f7bf96f2f49b7957ea8c139dad3c9228affad651d59cd7d"
    sha256 cellar: :any_skip_relocation, catalina:       "48bb51c269e07eb75f7bf96f2f49b7957ea8c139dad3c9228affad651d59cd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c4057241e2aafaa2b099467ace831ded0205903238148afb76a800e46960a5"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/firebase-tools/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
