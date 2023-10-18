class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "4ae92fcf7a68cfc395650eebeca426688b5751a6a315b64295a190d6e9ca3343"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "293714cada8e591a16d72303d4e5819189f1427af67b4c3870437db4f778533d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8da4131877220575733fa03b04e03235efcfeaa1d8e9b7f920516b4f908a7262"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d797a0260e64edd4582e7856d5fbe4661be598f292f2f25bf75bc1ad8e4e2ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "87bef3d45c2ffee2c12adbb42d339865103e3cb0d2d8c2884e14f9193532604d"
    sha256 cellar: :any_skip_relocation, ventura:        "0422cbd2633b721fb6c8b398a08489a6b2fa271354a9bb6a4ebbd06a8e0a0799"
    sha256 cellar: :any_skip_relocation, monterey:       "b794d1fa29efc0504ae63150987019aaeac221fea6029d322a5f578a682f6855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb9efa03e9272d5da6650de96fa1b9b2b31c500f8375556a0d360fcf22b830dc"
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
