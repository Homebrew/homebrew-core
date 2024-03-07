class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "54b1e793278b451ae7302fc01bbdcd2d3bb122b2824d84631507ad86822ba9b9"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e30dcdef0a5b65587a75a813a90d28a044ba5ca09a5036423929ac18c5e68509"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b83a9927b27994095f39f61ca761db82bb33b1cbf48e5b1e3a534b38fd6e229f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fc46c7a5905b9806a6ab0d3263747f9ad118e3c738fea50530616291b1d2b47"
    sha256 cellar: :any_skip_relocation, sonoma:         "b990e11771b704688dfaa64f5cd93079beed792d71c512cacdcd5d96a691b9b5"
    sha256 cellar: :any_skip_relocation, ventura:        "c2cbf5dac2c509849d881f173b915bfbd6bbd00b86a1e0b63658aef04286050f"
    sha256 cellar: :any_skip_relocation, monterey:       "f382ea5592b4f0f309a3155ced9be26231a52aa00f6d7a92d591179523b5e36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0a4d02acbf1745ea8e4c94a1f6abc5a8f2d0a4022f5bc7a91c40b6aa9d5145"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
