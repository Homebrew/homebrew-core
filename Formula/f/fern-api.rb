class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.62.0.tgz"
  sha256 "e85ee235c46efe72fda8d9ea4ed59f2df39ae97626f83851edc0f7b9986f8fe6"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b9bdb97fc5c98bcf9a77c88bc02a20136ea2077e114a7b0b29eea0b525ae0a6"
    sha256 cellar: :any,                 arm64_sequoia: "060adfdd3aee00292ea7867a7ca3343ccf24ed192f04060ce755ebf744562362"
    sha256 cellar: :any,                 arm64_sonoma:  "060adfdd3aee00292ea7867a7ca3343ccf24ed192f04060ce755ebf744562362"
    sha256 cellar: :any,                 sonoma:        "84f42590eed86ab89635f59be6222923b822de07d61a476c804d407b7b142e96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c67ac6c8dcd513837335b31334d8aa9fa1d3ac3367f7bfe22d4555a59b978759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63f63834588192e54db79cfecd9209d294a7120aad17102b7abca995d5ee3579"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
