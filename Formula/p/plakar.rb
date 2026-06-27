class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "6a23f149e7ac38009d2302b335df746be5408f775da89ef474f8b108bfb72cee"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "952a599361a4b6cf98d7e1f291ab74a122cf6b393c952a0e8a9d5c9402ebd040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd018430210b4af8e0c78cd2d28f19acba2c8b7ec1b5729b5cac459290482d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "204b58f3fd234537b2bb851a3000a2765457f09b3956af71da391299fb3ce3dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6c4f06fd295110ab8392053cfc75a782cfaf79a9668d4c82212b19ecc18b9d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919e588517b969beb049a300284f3a2a415104d5ca427b195831e46c8b58ad96"
    sha256 cellar: :any,                 x86_64_linux:  "2ced989873cf860bf28c56505e302cb3d577db22ef9fc7ba0833ad3e14f4e0ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end
