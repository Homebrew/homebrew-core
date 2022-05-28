class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "5d6b9986a175ed8ca789e55e42bb4d0f6089b408824b0654b57c7fcb91c06c07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58798c4137278fe2866e86c341e0f00cf4abdc8fcb90d9703d2d46cae3d550b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c660e2a3bbc8e64edff858588c78b4362d7085cdc41f473a23012ff546532d75"
    sha256 cellar: :any_skip_relocation, monterey:       "a8d71fdac3e0232e04ea14a9fe4737eb4e8a3b489a276201c2ca23b4540e0fea"
    sha256 cellar: :any_skip_relocation, big_sur:        "d33e9d255995095c13c2f03a00d75a1ce8ef740e4fc5837358468c8009809286"
    sha256 cellar: :any_skip_relocation, catalina:       "47b8a0c3faf831d56d80f685b430abfc9b66d9b06450f33e3dfa4d9c18d9ec80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68d6e25cf5eb1de6dafd86fd0f26a96296437926fd8acf3916588af27a7aa2b6"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
