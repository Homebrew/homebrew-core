class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "4c41719549e05dbaac1bc84828269e59b2f2032e76ae646da9b9e3b87e5a5fd1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f3f15380a7d6e7b258c6cfc0aabdec96d83f84dd343dbf21e2d7a19f2db2ca9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f69228c71a0d92a2bab223e2dfd845d50b50cd4f922de8c4efa36c15955cece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5578899d497324582e0dab5723cee3d8661d972ae6260c117f0362e97080deb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "91e8905c02015c1d4c416ae542fabd6fbe48ec38ae53d5505d6fda9eebfd1a57"
    sha256 cellar: :any_skip_relocation, ventura:        "0d6ec804c0da275d59daeee1e09a9c2be17490b903bb3697385e9e0fc6360db1"
    sha256 cellar: :any_skip_relocation, monterey:       "2993f719b6d663bed57f10ee5ff9e120cc9806d07f0d4ccb41f012d3d7a9aaf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa42cc40eedeafde73d6470da6dd0f304bccc561aaa719d6baceb334f54ad812"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 1
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
