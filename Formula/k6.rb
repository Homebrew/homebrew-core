class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.44.1.tar.gz"
  sha256 "d01e62527cf6b81d1dcb0c99da52cb1ea14692cbdc47bac850581478d095244f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef2d2b521997ea08fd7a935cdd131fa797d746790f7b9a48115abe7a8ecce60a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c05d0d0c7de26b0fa991866e0da4510a4ec0675e5d0ea3163e38062394799a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef2d2b521997ea08fd7a935cdd131fa797d746790f7b9a48115abe7a8ecce60a"
    sha256 cellar: :any_skip_relocation, ventura:        "45abeb3112759918868956e98d013bf1ec9a24493dfab2f13ba56f7e5bd44e50"
    sha256 cellar: :any_skip_relocation, monterey:       "45abeb3112759918868956e98d013bf1ec9a24493dfab2f13ba56f7e5bd44e50"
    sha256 cellar: :any_skip_relocation, big_sur:        "45abeb3112759918868956e98d013bf1ec9a24493dfab2f13ba56f7e5bd44e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8443088204ea9996689d1e4d8313de71b70f5992d5b5048aa4bcbbb49f489f50"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
