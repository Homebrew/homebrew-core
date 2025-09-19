class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.257.0.tar.gz"
  sha256 "948d8967f28d717f24a01486d59cda367d04afeafdf5fbc368c95fc44a89ff39"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bba6b73b826ba3f4de0d4bef1fe79161ba159c4b02ff727aba758a54f8655db4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e1e821d6885b6bfb34e7638c3536c4f336cea0d4abf11c4e8b924c074299d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7ce149c1488f584b201b999df0f1f7fe14bf106d252de5b268ff4fb4115852d"
    sha256 cellar: :any_skip_relocation, sonoma:        "86f0d9023ff91dd18e90486167ad792a7e1c8f7fe7fe20bd918a6464eaa3efe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1da82313d80d81ec98b34a0c48d8df501e806f395755c41ac3434d7aad293655"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
