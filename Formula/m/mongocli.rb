class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v2.0.1.tar.gz"
  sha256 "6b1f94cdafd1a2043bdd305a7d826a1c85ca30013d3f3e4161ac301df29f3354"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "mongocli-master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3e2fe7bf34cacae155aa1bb15c3537be7f47d15822ab4a5b831e26eec0fec4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1923558ef7d362d6f2333ae351e93f98df86ff2cbef8aacde4089b31791fd33a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1761f74c19826856255ea47aa6f29993995959316b7703ad7619660335086e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a302bd51bd6fe117b928ef48dcc9ed6a9f4738805a9188d243550cbab2b6625"
    sha256 cellar: :any_skip_relocation, ventura:        "dd4241a0ac85d555a4a57482ea5c8e091070484bb9a17244522b6f6b834559f2"
    sha256 cellar: :any_skip_relocation, monterey:       "29db0531c200abcd4c968fdfef694dccd232636942703b13813759458c1dbea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d7cd10f35645fe2f618f006a444fecc35fd26d29ed4a3c8ebcb9f272a81f586"
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
