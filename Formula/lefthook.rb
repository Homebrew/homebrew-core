class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "d23ccd5b944cdd2e3050850097e424cfbff75376add89dd3abb63ba99fc00869"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34b574e79dbc203f5b3ce508328128a62918388a71b2e670d9b3d334138e0553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b04cfff90845fb774279f22a5689cfed68d2e9c7ca93775f14bba30a5812d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b3d0637f8e5d39f931405e1ae40582865b3ca7a98db7b6809a508adc6d35814"
    sha256 cellar: :any_skip_relocation, ventura:        "873251dcc28372413d336ce1ba86da94edfc2a5aea46617bd1bbbd77a255d5cf"
    sha256 cellar: :any_skip_relocation, monterey:       "73f611cc55640981e4a7bc2fca5379ac07dfbd6075e411e3e27bd596c226c632"
    sha256 cellar: :any_skip_relocation, big_sur:        "a86819d95a3140ade910b8df5d05dbab51440183b6a68b506817ce3ed28e2393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff707fdef2392c49d02dbec21353f19eba3e4838661925d86c51f4a3118c751"
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
