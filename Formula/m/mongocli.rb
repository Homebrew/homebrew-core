class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v2.0.0.tar.gz"
  sha256 "1eb088015fd6adcfcf067fdf326c44474192512c61d53cca1b8be8bd5780099a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "mongocli-master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72b87eb842bfd16071cd5ea1b2996c4e9651b108540e6914eafcb31ab04e59c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28fdf39628125d15932d193ce43b03ccbc32b12ea22781ee77644f2b1b3f4762"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b60bf017227701fa7364724dd0e7096498356573baf954d02147cb3b595c8be8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e224f0d26c72f12621d50022ad01b78285b8cd94542866a0a0c8b25648cb2902"
    sha256 cellar: :any_skip_relocation, ventura:        "b0b45a1bfaa83d55e208bc7785a5e9669f1fcd34cb2d830bc1365f6afd38c7f1"
    sha256 cellar: :any_skip_relocation, monterey:       "36e3bcf621fa700f1c714c847d7a94cae0179491a6f7773d93974d82b1453e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "080ef0e352c7f73aeff5f247b071aaea65c0bba41e06a88a4453cb1f78c51b7e"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
