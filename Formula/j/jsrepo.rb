class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.5.0.tgz"
  sha256 "a10ab3fbef4c301c50abfffa4f58d7a49c6f32d570be36413b2886a72332ef5f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11ace77c1363f1b6841f1aef2e3f9b3d9c5d9e8286b4d8b2abe26a479a7c6f95"
    sha256 cellar: :any,                 arm64_sequoia: "ca67ebc5e3e61ae3a9adda819c7d03f336de3a22752c63127030cb3f5f59c2b3"
    sha256 cellar: :any,                 arm64_sonoma:  "ca67ebc5e3e61ae3a9adda819c7d03f336de3a22752c63127030cb3f5f59c2b3"
    sha256 cellar: :any,                 sonoma:        "9f746be8e0ae64a46095cc90c361f3a1068c12902005726a68760c4c3032b9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9be6c56c8915f28bb6f4cdd61f55ce421807904a746a172d81f9a6ea860402d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e40c801af4a4451a9a0e232d117c62f7e537844212271c97b7e9709c58a92eb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
