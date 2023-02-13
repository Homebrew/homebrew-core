class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "40b0e705cff6a0ed74f29e6a7da8ff98bf8f7e22db92f7fbb90a0dad3cec64fc"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95c92b5eb370a221766296e9b4afb2f4d0838f7779bf0f61a4ee82a7f9ee56f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c55cab66d70c77fdeaadb58064617a523690a598de0012d8de85677841c49f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fae6a7209fd373a1c1e16d02ac59050a43c823acd6e11cefcdd162102fbfa04"
    sha256 cellar: :any_skip_relocation, ventura:        "946035f77aeaa73f2fe7e953d83a7b61732dd885dabec3f193cc6b77346fe85c"
    sha256 cellar: :any_skip_relocation, monterey:       "d48259b55eeb989204859478660f77daf28fbc82c4f9a064638c9a6a9a3a757e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb1fe4bce95e81ec80383442ad01afd830dfc0152bc60a8d58756a16aaa1b77e"
    sha256 cellar: :any_skip_relocation, catalina:       "15b92bfe7ed9c3a1d1c11c3510965cb4d865d3be4a17d3f4c67d19f48dd2a646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "851f270aebdd3c2932b363b6afd9002a5ad9bda706df74d488b270fdff2ea83b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    assert_match "connect: connection refused",
      shell_output("#{bin}/popeye --save --out html --output-file report.html", 1)
  end
end
