class Pdtm < Formula
  desc "ProjectDiscovery's Open Source Tool Manager"
  homepage "https://github.com/projectdiscovery/pdtm"
  url "https://github.com/projectdiscovery/pdtm/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "5aa5611e3a61df37a2e4030fd8742d4a1278840fe91c1e1fde129aab81f4fe45"
  license "MIT"
  head "https://github.com/projectdiscovery/pdtm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f5267c24f3b4dd5f19c8eeadc4a6582cf7b9d1dfc990c083b90415a5ad460cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9ef2bbd6f036e5c3ce6629905c5c02908ca51440cad3319094771c32077962f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96751029319e738c50fa86960e7764d68def5c5b0a08b86d4bb7aa1aafabb1ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f8cff333aeb9050e11e8e346b54855c55a2690b697ae033db3b41a239310df1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0f4d7527f5baa186c8cfad4d0d956b7494af38818efeee4adbc09f908b7e0cd"
    sha256 cellar: :any_skip_relocation, ventura:       "1783d258be29384be1a3db469de6e1cd8bdfc9d077f0c6bd4bfe8861fc00f1fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c521caaed87a6e797fe969cd5f555935cea1eb49aced09638e8dfaa1b427cade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfea4fd9e25c41239d8126f941591db53887aa456d43396bfbad42fe29b19bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pdtm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdtm -version 2>&1")
    assert_match "#{testpath}/.pdtm/go/bin", shell_output("#{bin}/pdtm -show-path")
  end
end
