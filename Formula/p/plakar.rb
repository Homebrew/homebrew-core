class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f44380395c39889289b31a5f20432d85a86eba5283a804d4601ce8ec25a6c527"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2d4fba3e280662ff175824057c5f49ef187b21bc721b0b0ce68ead5b3a43154"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5884c995284534a3bbf0ec8b423bae5d6df983c0a2097ee6a931c10910f8e43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4944a3b21f5403819d828c97eb6ce4db0f7f2fe75937b000a73151d2437dd6e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd992400c4f77635b435d2290609657feb9e30fd16e410d046cf295ae4a67324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d26c0eb579ab361c9ff4dcc1a721c55f673997a29e0f2da4a102b8c14a3b2934"
    sha256 cellar: :any,                 x86_64_linux:  "1c0633f74d3327f620153b90d0c99c7413df710e64f07921ba055a642e9f8fc8"
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
