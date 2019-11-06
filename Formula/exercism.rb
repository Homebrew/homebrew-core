class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/v3.0.13.tar.gz"
  sha256 "ecc27f272792bc8909d14f11dd08f0d2e9bde4cc663b3769e00eab6e65328a9f"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d90d9790c3afc60533cedf8e2fdafa9c74659b4f706326810aa2e556efabe9c7" => :catalina
    sha256 "f00c53d1ee4bc4cf935ad4c5039b665078b1e6d81687b55ae988a621fe2d93b8" => :mojave
    sha256 "04f72181da1a9cde08e87357cc1494252f0290d18646df0f3bffec7673c26e7e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/exercism/cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-s", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
