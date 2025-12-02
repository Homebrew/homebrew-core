class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "203d7f4d09ae9ba6e15ec0d6adde9c499ec280d521746de4a4b10775af9e1469"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afa584a42874e71fc08f8d6f1bcb89f3fd9ab21d9fa3b38ee3edb88b970dfe9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afa584a42874e71fc08f8d6f1bcb89f3fd9ab21d9fa3b38ee3edb88b970dfe9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afa584a42874e71fc08f8d6f1bcb89f3fd9ab21d9fa3b38ee3edb88b970dfe9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc5d3f8a999464bd7e4870c0394773f099467b32f7b9a3d7a0310e80262a3159"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49589921c6513b84795cdb576c8cd640155cb073eff8839146f323f161f9dae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bfa94ebf071a9a25557db20883e24dde2ff035cae2ae461ba2fb66d35b54145"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output(bin/"cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
