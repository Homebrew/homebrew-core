class Leetup < Formula
  desc "Command-line tool to solve Leetcode problems"
  homepage "https://github.com/dragfire/leetup"
  url "https://github.com/dragfire/leetup/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "f7fd0fed6cab7e352bf6ca5e4d0dd5631d90ef4451e27787236ff4ade36de3b8"
  license "MIT"
  head "https://github.com/dragfire/leetup.git", branch: "master"

  # This repository also contains tags with a trailing letter (e.g., `0.1.5-d`)
  # but it's unclear whether these are stable. If this situation clears up in
  # the future, we may need to modify this to use a regex that also captures
  # the trailing text (i.e., `/^v?(\d+(?:\.\d+)+(?:[._-][a-z])?)$/i`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c8be72a382a3802cc06ff3e1584b140b2a7d09a4812a52bcef0b88c92c8258ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d1b4514ce4129a82214372e208fcc2e6d6dc746fb60ed69675d69628c7fbdd72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8869f57b3f3a3c9de61c30dd2ab987ec81c82b46bcaa9a6426c44ff1ca05c967"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2310aadadf29ce3199edf0b7d749208b282916355fe00d8fb2f39bb645b355f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c300dbf7a8021139b8113ca134d001ea57c2438598f7e8957807fba0966c7e15"
    sha256 cellar: :any_skip_relocation, sonoma:         "1934aa6e87b0d6b10a688cab48469b40387536d8cb57cfd4f6e4fdd976f4f437"
    sha256 cellar: :any_skip_relocation, ventura:        "9cf0c87808ed0962e2fdb6b1ccb1c4527c1007883912a2b9d1df26d2dedf6569"
    sha256 cellar: :any_skip_relocation, monterey:       "6d28bd176e651bce4d0eda8cc74f78b8dcc74453e1c165000e6f28b8984d7ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4ea3eaa914822acc5f7759fee87fef3ecce87cb7c2105a797c640a09032c20a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f06e66d4529f7489b4ca0b9bcf9976c376015d6ea635c0c00a09adcd4439dca"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/leetup user --logout")
      User not logged in!
      User logged out!
    EOS

    assert_match version.to_s, shell_output("#{bin}/leetup --version")
  end
end
