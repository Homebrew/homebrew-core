class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.7.4",
      :revision => "c8adaa920a8e0fe0cc172868a3811e643661f19e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2afbfee024cbe59bca718405e6966de2ac27df6ea5248931dac316aa1d9ab6af" => :mojave
    sha256 "9b5ca7083c9e31a46fa42e9aee2ea88591aec585d192419bf344f844cfac0a59" => :high_sierra
    sha256 "f45f1ff18d5b8bc445afd3cc6f3e202d21817bcaaca690e9ffe1947c3f559334" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/jesseduffield/lazydocker"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-mod", "vendor", "-ldflags", "-X main.version=#{version}", "-o", bin/"lazydocker"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
