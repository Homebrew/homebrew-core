class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.10.1",
      revision: "f60089654267c0990f076186b2ced2eb307d2cbe"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dee6d2d2fa1bdd874da33fb577ee8e2a8064c4ed2d40f9edfe8f0d1b5aad7c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d250f4b20940dbc6ef5da8143d91ceeae81a873bd6819e5eeee83a16f8dea3ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5be06b4769465e2cae5c66b654b54eb4289b7c324069377b87cf2c256e5b3e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "51adefd0138c4bb007cfabaeba674776d1133bc7477f52f912ddb74938a61def"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eca19f878ce105b0d68c6c8053fdce5df87e881d16cc87012b2b50f1f9d45de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34d64db75063f3f29c6001ff167ea5388e881190fdad087d270af3f8c5ff1ee"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
