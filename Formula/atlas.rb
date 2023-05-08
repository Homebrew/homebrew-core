class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.11.0.tar.gz"
  sha256 "21c80ba77701a6db910eb2c1e83b3a2323612fb6572756269becc22018b13451"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05fdac757f1ae1788c0f61354ceab26607289a1d77644c6d573f002750ef5ea2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb7866f77b38b446c052f489c2a35e24b3709de74b3638b2a1b45f14267c000b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c07a587e4c7029783dc1bf4a022a386be26360f10bcab0c94eda755be5ea3022"
    sha256 cellar: :any_skip_relocation, ventura:        "c6109069f7857e013f2d2d902f14d2ac4089b4bed07722a660a80ecb5ace4761"
    sha256 cellar: :any_skip_relocation, monterey:       "2718da632fb7dfb67af608ad6af1f76a1e77517a05ee6ccba2efe9dd7c82a802"
    sha256 cellar: :any_skip_relocation, big_sur:        "275b1af60fd4ee7c778960684942a595dae4bf6acff8d2a397675aeb9b40ae1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3735e170dd397769a7a423345160cc01de772bc0f13fb8c19b83680b6799f6cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
