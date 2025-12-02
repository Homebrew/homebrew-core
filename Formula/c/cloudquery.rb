class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.30.5.tar.gz"
  sha256 "30a147b27a95180cf5dafb11247ba3d6ac9a26ea355517872fabe7cd816107f1"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d3433d699df216d7e35c53582bae90e8fe624622485feddd7cafcafecc52910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d3433d699df216d7e35c53582bae90e8fe624622485feddd7cafcafecc52910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d3433d699df216d7e35c53582bae90e8fe624622485feddd7cafcafecc52910"
    sha256 cellar: :any_skip_relocation, sonoma:        "023eada661677dbafd857b8d20a8203f8ee8eaa9af45b051f6d91e5ee21f3f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8069767ac02b0cf24402c1c6ec29b918a4935c4c443a8f73c65f08d3dd073d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cca33eb1b8247bc945a6c3368b65591f325e407e837044c7ddde0201c2091774"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
