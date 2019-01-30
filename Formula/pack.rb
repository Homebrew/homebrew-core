class Pack < Formula
  desc "Command-line tool for building applications with Cloud Native Buildpacks"
  homepage "https://buildpacks.io"
  url "https://github.com/buildpack/pack/releases/download/v0.0.9/pack-0.0.9-macos.tar.gz"
  sha256 "6b8ed842d91ddff35f6aa96fefc4ecde767a4ee7a3bdc772eba0a14c123cd47b"

  def install
    bin.install "pack"
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
    system bin/"pack", "create-builder", "homebrew-test", "--builder-config", testpath/"buildpack.toml"
  end
end
