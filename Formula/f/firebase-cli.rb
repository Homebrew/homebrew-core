class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.33.0.tgz"
  sha256 "ad98502889bd7e932d6bf77934a39c757bf6b8632c1189ca4f68e71fb26d5d1a"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "4afcb4b208eeab14661e375fd619c3f4fdee7b09b9ec93661641fcd390ac9242"
    sha256                               arm64_sonoma:  "6ec693a9df1ebe008e9d6aaf9b8f6e29ddd281727c47d5afb65d3c95b6e8a2f9"
    sha256                               arm64_ventura: "70987008fbe4c69b519e80e3b46785deced45ff665c55406704059200eb88f58"
    sha256                               sonoma:        "b138207da8bf4c241e6108ed9f9b24ce12fcc2809d998efdaeadcb2f9de52d92"
    sha256                               ventura:       "93b77461a9b2fee62a447bbe5c43e833179d6ef5ee31577aaf8d10b31fd78667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4a493004083c07f13f4536b75c6a3fdac1ed61ee1ca8c9788b85d078ad32e5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}/firebase init", 1)
    end

    output = pipe_output("#{bin}/firebase login:ci --interactive --no-localhost", "dummy-code")
    assert_match "Unable to authenticate", output
  end
end
