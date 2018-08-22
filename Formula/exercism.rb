class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.7.tar.gz"
  sha256 "2d67a56b029769b4bad7006968704f4ea943e1e3f57b0a3c5b2b9c066c5d9ad0"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "592d1c6ea90da7930185a969a9e70481eb3d9d81c276bba78586ca760a3bf397" => :mojave
    sha256 "0797f3e428dd6793ceabf3d53b21719a19b13b41e13f8a7e687efb9f0fa8de75" => :high_sierra
    sha256 "faf2b756e594c79e3808fbf6d26e7bbd255fc0c7a443054f779c8e8edf5f369c" => :sierra
    sha256 "c26332bf4bbd8a00b5c3bd2a924dfd7d54b097131c653c577b43e865917d8e6f" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/exercism/cli").install buildpath.children
    cd "src/github.com/exercism/cli" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
