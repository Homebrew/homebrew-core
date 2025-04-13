class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.8.2.tar.gz"
  sha256 "8cdf632cf04b03d761b4b50fb472106302d25f84798575271c949f53facb21ba"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726541567057e4ede541f47b85fb8cb1de41f218d8a24b327e17b842d5eb3065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fecc2fde2ac28a529274b617cd8f6a98ce063c0165fe1d8a496e173ce55e5ee5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b65871000131e4da7c92d52ee26bd352afb756da2436067168a2902049d298e"
    sha256 cellar: :any_skip_relocation, sonoma:        "09b149f28ec0db60d0fe331b0a39e71a575b3cf2559e91bb80d71eecaab09688"
    sha256 cellar: :any_skip_relocation, ventura:       "c4b5bd90ff41243a698385f6a392fb5598e24f18970503ec331b4e269a579d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f4783189b889c929ccc8add522447372680356ebf429da26125091cb821a09"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_path_exists testpath/"mars/go.mod"
  end
end
