class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.43.0.tgz"
  sha256 "6c6c722f7197fe51921e3bed9accf12da83b9969d81bc4da6282467f45ceac8d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85c1c067bce5f5f5cfa13a4c1c7e346bd742d437f39658202f8c36400a458c94"
    sha256 cellar: :any,                 arm64_sequoia: "a1bf15fc46d11698a996b8b7c9cbb204ac7c96611e8c009892eda259398c6dfb"
    sha256 cellar: :any,                 arm64_sonoma:  "a1bf15fc46d11698a996b8b7c9cbb204ac7c96611e8c009892eda259398c6dfb"
    sha256 cellar: :any,                 sonoma:        "25e9ec6f7e5c3cb88bfec6fe854ceb051e8af0bcc37fc1a9d88226531ef655ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d87310fa7595c312a4421c06cb41d89eba6dd0fb227054bd879c85dd0fc17bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e4021fd9d223add21cc132c81d66e04f45dcbdcfc73136b51e1935e94d7b844"
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
