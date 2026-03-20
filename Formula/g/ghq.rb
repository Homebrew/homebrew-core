class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.9.4",
      revision: "39ead659b5d59d31d104a46555b750a6f04d6771"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2852ad6f2541fc494efe52ea1ac8d21d3a25973481716652ad8d61cc682332c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aabd6bf00980f0632a4d3238e6e010765a2bdd6a81f7503f9729674f34caf83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85029a5efa0a92e1371bd6e05d143e8b5c1c5c428a432859da3f948a6e7ab2b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b5fee4f04d74bb7ce012c9b5acaf215e71d531e38aaf0928dcea3d3c8d6a566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "497b9ade787adbf8ac84be4c71d0e539fc158d063d33ba160aed0da4c447a6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "841e15334b92f9fcce3c3dce188f3b0104d3b238ab2bf6fdb9179a6e05e2a959"
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
