class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.50.0.tar.gz"
  sha256 "a1ff924205c13873d81a21eb9f8b724bafac282fbda9b6615ff5cdd0b4712bf6"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f62029f596b2559ab6558f88e4cd352ce8e1327b624c1396baf32871a97796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f62029f596b2559ab6558f88e4cd352ce8e1327b624c1396baf32871a97796"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5f62029f596b2559ab6558f88e4cd352ce8e1327b624c1396baf32871a97796"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d38af625803cd65443ac0ae658ae77760b3fe85d6630090933bd615535a18a"
    sha256 cellar: :any_skip_relocation, ventura:       "b7d38af625803cd65443ac0ae658ae77760b3fe85d6630090933bd615535a18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ccde58732799f990943aa038cf066116eb45a4b14b804e809bdcbfa6b561d1a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
