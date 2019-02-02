class Pack < Formula
  desc "Command-line tool for building applications with Cloud Native Buildpacks"
  homepage "https://buildpacks.io"
  url "https://github.com/buildpack/pack/archive/v0.0.9.tar.gz"
  sha256 "b25028e738ef14cb1df108b8cf12a2302a4a2ec9d88c03c3ccf0638a8fef1994"

  depends_on "go" => :build

  def install
    ldflags = ["\"-X main.Version=#{version}\""]
    system "go", "build", "-o", "pack", "-ldflags", ldflags, "./cmd/pack"
    bin.install "pack"
    prefix.install_metafiles
  end

  test do
    testdata = <<~TOML
      [buildpack]
      id = "sh.brew.buildpack.test"
      version = "0.0.1"
      name = "Test buildpack for Homebrew formula"

      [[stacks]]
      id = ["io.buildpacks.stacks.bionic"]
    TOML
    (testpath/"buildpack.toml").write testdata
    output = shell_output("#{bin}/pack create-builder homebrew-test --builder-config #{testpath}/buildpack.toml")
    assert_match /Successfully created builder image/, output
  end
end
