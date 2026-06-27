class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "a3ddbbbe97376a240ddb37e0bfd1978b291c9a9ba23cd5883433b00dace2ee9c"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "589185d9e27ab2a2ace05d316155a3e7fa8fad2d1d478054b6c69f1fcf17d80d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51f26866b7fb7c5896a279f975ed419a50ccd4757ecfaa8f66d87a79dc74eb68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c43c9146d4aef96bd853573d2ac182b61f691b15da7d3c02cf2c3e4b42656e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "1792243fef3afe8355b46648cdbd087c673451ef6d2e3d0609688386de300324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55b07db0b03f916584924ff8dd227685164bf20946cfacb2483159f4567587c2"
    sha256 cellar: :any,                 x86_64_linux:  "3e9e0e3769a41c2ef511bd5315086137a984af78e1ebaca123dc21fb8f2d705a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pv-migrate"

    generate_completions_from_executable(bin/"pv-migrate", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pv-migrate --version")
    output = shell_output("#{bin}/pv-migrate migrate 2>&1", 1)
    assert_match "source", output.downcase
  end
end
