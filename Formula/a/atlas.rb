class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "572e85b029682e628475b4b8dfc330e10644810a4d7cba3daaa0cd7d7bdc8f34"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    manifest_sha256 "3f7581aea9158a1a4c879007994521ee5381359bd5752ae8dd47ca53574c7166"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b25d6869b2a7a4f6da59d0a017a239907f352e557fd1a3d61617d9ded12ad412"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2a98d7d13fff6203313a365a1379cbbec5c764c5560bd78eb1f7b364c2ff3df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c8040c7f64aeb85040ec47b206e6d53a616404f4db54e1069457e249d4d754f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f8bddb46cccc5bbdbdf2cd9997844a65ce8f56db7f29dcb34d1dde7deecdcdf"
    sha256 cellar: :any,                 x86_64_linux:      "cbb98fc4a7bd019415a220cdc4f7b46db94e5f7b9a919670f2537b5751ed72bb"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "cmd/atlas"
  end

  def install
    ldflags = %W[-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
