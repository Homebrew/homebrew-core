class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.2.1.tgz"
  sha256 "337ca7314ceec9fa35b734eda271fca828907d290c3635cc962544e0409e8c55"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "bb4206a440e4d6522dd893789dbbbe9fd9c20dbb399e92fee5cc3577388cfc80"
    sha256                               arm64_sonoma:  "762ff39542792867872ec6607a0e590a726f39e7961f51ba356da74118957cf3"
    sha256                               arm64_ventura: "0da6db0e297a266d149c4e9d8011828cf6c56820f474e3560a5abb95152731a0"
    sha256                               sonoma:        "0605f8bac467b0de4c1906a3cbbe3b654b632873187d8e56145a7a9ae3895ac6"
    sha256                               ventura:       "7de506f3d480c0fb2cfd5f26a758dad0f02f2124ddd55af162c61cb4b679aa04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5424c5d29459a998b783c96a3a91d557acc0e5f795dadc8e61e98cb1da8627e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2af05490019c2280ef893abf99cf17e492a5654b7f16a459dd26259cf128c6e"
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
