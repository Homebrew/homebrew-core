class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "4748d722f66859f24096f21c750f5d0961b906f81524ca3542dd1f206698f120"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00afc5743bb99def2fe714eb4e53e74b820b34eb9d6645e789876ec2737fad43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00afc5743bb99def2fe714eb4e53e74b820b34eb9d6645e789876ec2737fad43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00afc5743bb99def2fe714eb4e53e74b820b34eb9d6645e789876ec2737fad43"
    sha256 cellar: :any_skip_relocation, sonoma:        "931925d2fb70f5853905dab848cdd4de31de4803ed157f8595eac575bae73b07"
    sha256 cellar: :any_skip_relocation, ventura:       "931925d2fb70f5853905dab848cdd4de31de4803ed157f8595eac575bae73b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2bec25970b0507190160fd5a8c3d777f286ff018517972039a98bc9152b20b0"
  end

  depends_on "go" => :build

  def install
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    bash_completion.install "completion.d/aptly"
    zsh_completion.install "completion.d/_aptly"

    man1.install "man/aptly.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aptly version")

    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
