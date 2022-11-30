class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "1a4e6855ffcaeadd787bc3fde7a5641b0ca7406fbd08c41f5567ee6f26b10e27"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7509d2b5d082b70e8e0af872e545b5ad7747902879e5fcc61f2c310fa212d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57535aadf91cec738070aa48bb77dcefddc67f6f8f44de68bacf28e3ee307ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "333fb565c49aed503d3e7a806764ec528d142c7160e295dc95ddc6fade53ae5d"
    sha256 cellar: :any_skip_relocation, ventura:        "7856727ab144c38cb8da84a3182d9961fba7b5aef0a196a13d5f3855733d4259"
    sha256 cellar: :any_skip_relocation, monterey:       "e495d55239947696d918fb5c726daa60e95c85f66300b5475c3a5c2e511d4900"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f13eefb342c030da993f1ae90a49b84bac3f169bd30cb6984015893737da6ca"
    sha256 cellar: :any_skip_relocation, catalina:       "f6e1c5fe2da70b7ba41e5b8ad762e8ba6e425aad4a41d226f3e33569c6d47c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f3dafbffcc80d96263d1f454fc0233d1c26f91a305ada53f89204d6ba8ebcdc"
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
