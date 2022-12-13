class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "bb6492f840d67fb5153563916ce11bf79b8b0edd6950afbbc4f7d4eecb97f63f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "817b5b0d69429f3ca590b0c2fe697fa622974681dadec78fbcdaf2665c80d21b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d7e913a058512bfc8c08c0ca7c9ba95e64e4b01abb792c693993662f5204c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "419a2eafd876208984cf24623bea2c1e9abbc185cbeff446711d44ba9447ff15"
    sha256 cellar: :any_skip_relocation, ventura:        "b0c7a3c0307bf8ef5eb5b754f2a3aad783f3db07611b8bccdfe60217366ac2aa"
    sha256 cellar: :any_skip_relocation, monterey:       "13e5502bae2e82aab1e53e2958da9349d5f452e373e0784bdaed63a564a12d9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9734a61731db4a8acec8fd475b10be57df86191f65fc9c4cb7f16ec5c3a44e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d21e6f1c9c4af44ebfba41a76193532b73d6463ccfa64e42a38e628a35d51765"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
